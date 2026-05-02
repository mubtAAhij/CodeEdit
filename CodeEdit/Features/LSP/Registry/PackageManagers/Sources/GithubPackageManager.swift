//
//  GithubPackageManager.swift
//  LSPInstallTest
//
//  Created by Abe Malla on 3/10/25.
//

import Foundation

final class GithubPackageManager: PackageManagerProtocol {
    private let installationDirectory: URL

    let shellClient: ShellClient

    init(installationDirectory: URL) {
        self.installationDirectory = installationDirectory
        self.shellClient = .live()
    }

    // MARK: - PackageManagerProtocol

    func install(method installationMethod: InstallationMethod) throws -> [PackageManagerInstallStep] {
        switch installationMethod {
        case let .binaryDownload(source, url):
            let packagePath = installationDirectory.appending(path: source.entryName)
            return [
                initialize(in: packagePath),
                downloadBinary(source, url: url, installDir: installationDirectory),
                decompressBinary(source, url: url, installDir: installationDirectory)
            ]
        case let .sourceBuild(source, command):
            let packagePath = installationDirectory.appending(path: source.entryName)
            return [
                initialize(in: packagePath),
                try gitClone(source, installDir: installationDirectory),
                installFromSource(source, installDir: installationDirectory, command: command)
            ]
        case .standardPackage, .unknown:
            throw PackageManagerError.invalidConfiguration
        }
    }

    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        switch installationMethod {
        case .binaryDownload:
            PackageManagerInstallStep(
                name: "",
                confirmation: .none,
                handler: { _ in }
            )
        case .sourceBuild:
            PackageManagerInstallStep(
                name: "",
                confirmation: .required(
                    message: String(localized: "github.package.install.confirmation", defaultValue: "This package requires git to install. Allow CodeEdit to run git commands?", comment: "Confirmation message for allowing git commands")
                )
            ) { model in
                let versionOutput = try await model.runCommand(String(localized: "github.git.version.command", defaultValue: "git --version", comment: "Git version command"))
                let output = versionOutput.reduce(into: "") {
                    $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                guard output.contains(String(localized: "github.git.version.prefix", defaultValue: "git version", comment: "Git version prefix")) else {
                    throw PackageManagerError.packageManagerNotInstalled
                }
            }
        case .standardPackage, .unknown:
            PackageManagerInstallStep(
                name: "",
                confirmation: .none,
                handler: { _ in throw PackageManagerError.invalidConfiguration }
            )
        }
    }

    func getBinaryPath(for package: String) -> String {
        return installationDirectory.appending(path: package).appending(path: String(localized: "github.bin.directory", defaultValue: "bin", comment: "Binary directory name")).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "github.initialize.step.name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"),
            confirmation: .none
        ) { model in
            do {
                try await model.createDirectoryStructure(for: packagePath)
            } catch {
                throw PackageManagerError.initializationFailed(error.localizedDescription)
            }
        }
    }

    // MARK: - Download Binary

    private func downloadBinary(
        _ source: PackageSource,
        url: URL,
        installDir installationDirectory: URL
    ) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "github.download.step.name", defaultValue: "Download Binary Executable", comment: "Installation step name for downloading binary executable"),
            confirmation: .none
        ) { model in
            do {
                await model.status(String(format: String(localized: "github.status.downloading", defaultValue: "Downloading %@", comment: "Status message for downloading a URL"), url.absoluteString))
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120.0)
                // TODO: Progress Updates
                let (tempURL, response) = try await URLSession.shared.download(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw RegistryManagerError.downloadFailed(
                        url: url,
                        error: NSError(domain: String(localized: "github.error.http.domain", defaultValue: "HTTP error", comment: "HTTP error domain"), code: (response as? HTTPURLResponse)?.statusCode ?? -1)
                    )
                }

                let fileName = url.lastPathComponent
                let downloadPath = installationDirectory.appending(path: source.entryName)
                let packagePath = downloadPath.appending(path: fileName)
                if FileManager.default.fileExists(atPath: packagePath.path()) {
                    try FileManager.default.removeItem(at: packagePath)
                }

                try FileManager.default.moveItem(at: tempURL, to: packagePath)

                if !FileManager.default.fileExists(atPath: packagePath.path) {
                    throw RegistryManagerError.downloadFailed(
                        url: url,
                        error: NSError(domain: String(localized: "github.error.download.failed.domain", defaultValue: "Could not download package", comment: "Error domain for download failure"), code: -1)
                    )
                }
            } catch {
                if error is RegistryManagerError {
                    // Keep error info for known errors thrown here.
                    throw error
                }
                throw RegistryManagerError.downloadFailed(
                    url: url,
                    error: error
                )
            }

        }
    }

    // MARK: - Decompress Binary

    private func decompressBinary(
        _ source: PackageSource,
        url: URL,
        installDir installationDirectory: URL
    ) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "github.decompress.step.name", defaultValue: "Decompress Binary Executable", comment: "Installation step name for decompressing binary executable"),
            confirmation: .none,
        ) { model in
            let fileName = url.lastPathComponent
            let downloadPath = installationDirectory.appending(path: source.entryName)
            let packagePath = downloadPath.appending(path: fileName)

            if packagePath.pathExtension == String(localized: "github.extension.tar", defaultValue: "tar", comment: "Tar file extension") || packagePath.pathExtension == String(localized: "github.extension.zip", defaultValue: "zip", comment: "Zip file extension") {
                await model.status(String(format: String(localized: "github.status.decompressing", defaultValue: "Decompressing %@", comment: "Status message for decompressing a file"), fileName))
                try await FileManager.default.unzipItem(at: packagePath, to: downloadPath, progress: model.progress)
                if FileManager.default.fileExists(atPath: packagePath.path(percentEncoded: false)) {
                    try FileManager.default.removeItem(at: packagePath)
                }
                await model.status(String(format: String(localized: "github.status.decompressed.to", defaultValue: "Decompressed to '%@'", comment: "Status message for successful decompression"), downloadPath.path(percentEncoded: false)))
            } else if packagePath.lastPathComponent.hasSuffix(String(localized: "github.extension.tar.gz", defaultValue: ".tar.gz", comment: "Tar.gz file extension")) {
                await model.status(String(format: String(localized: "github.status.decompressing.tar", defaultValue: "Decompressing %@ using `tar`", comment: "Status message for decompressing using tar"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        String(localized: "github.command.tar", defaultValue: "tar", comment: "Tar command"),
                        String(localized: "github.tar.flag.xzf", defaultValue: "-xzf", comment: "Tar extraction flags"),
                        packagePath.path(percentEncoded: false).escapedDirectory(),
                    ]
                )
            } else if packagePath.pathExtension == String(localized: "github.extension.gz", defaultValue: "gz", comment: "Gz file extension") {
                await model.status(String(format: String(localized: "github.status.decompressing.gunzip", defaultValue: "Decompressing %@ using `gunzip`", comment: "Status message for decompressing using gunzip"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        String(localized: "github.command.gunzip", defaultValue: "gunzip", comment: "Gunzip command"),
                        String(localized: "github.gunzip.flag.force", defaultValue: "-f", comment: "Gunzip force flag"),
                        packagePath.path(percentEncoded: false).escapedDirectory(),
                    ]
                )
            }

            let executablePath = downloadPath.appending(path: url.deletingPathExtension().lastPathComponent)
            try FileManager.default.makeExecutable(executablePath)
        }
    }

    // MARK: - Git Clone

    private func gitClone(
        _ source: PackageSource,
        installDir installationDirectory: URL
    ) throws -> PackageManagerInstallStep {
        guard let repoURL = source.repositoryUrl else {
            throw PackageManagerError.invalidConfiguration
        }
        let command = ["git", "clone", repoURL]

        return PackageManagerInstallStep(
            name: "Clone with Git",
            // swiftlint:disable:next line_length
            confirmation: .required(message: "This step will run the following command to clone the package from source control:\n`\(command.joined(separator: " "))`")
        ) { model in
            let installPath = installationDirectory.appending(path: source.entryName, directoryHint: .isDirectory)
            _ = try await model.executeInDirectory(in: installPath.path, command)
        }
    }

    // MARK: - Install From Source

    private func installFromSource(
        _ source: PackageSource,
        installDir installationDirectory: URL,
        command: String
    ) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: "Install From Source",
            confirmation: .required(message: "This step will run the following to finish installing:\n`\(command)`")
        ) { model in
            do {
                let installPath = installationDirectory.appending(path: source.entryName, directoryHint: .isDirectory)
                let repoPath = installPath.appending(path: source.pkgName, directoryHint: .isDirectory)
                _ = try await model.executeInDirectory(in: repoPath.path, [command])
            } catch {
                throw PackageManagerError.installationFailed("Source build failed.")
            }
        }
    }
}
