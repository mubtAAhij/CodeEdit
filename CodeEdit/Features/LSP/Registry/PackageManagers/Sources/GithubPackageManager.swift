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
                    message: String(localized: "github.install.permission", defaultValue: "This package requires git to install. Allow CodeEdit to run git commands?", comment: "Confirmation message for running git commands")
                )
            ) { model in
                let versionOutput = try await model.runCommand(String(localized: "github.install.version-check", defaultValue: "git --version", comment: "Git version check command"))
                let output = versionOutput.reduce(into: "") {
                    $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                guard output.contains(String(localized: "github.install.version-pattern", defaultValue: "git version", comment: "Git version string pattern")) else {
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
        return installationDirectory.appending(path: package).appending(path: String(localized: "github.binary.path", defaultValue: "bin", comment: "Binary directory name")).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "github.initialize.title", defaultValue: "Initialize Directory Structure", comment: "Title for directory initialization step"),
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
            name: String(localized: "github.download.title", defaultValue: "Download Binary Executable", comment: "Title for binary download step"),
            confirmation: .none
        ) { model in
            do {
                await model.status(String(format: String(localized: "github.download.status", defaultValue: "Downloading %@", comment: "Status message for downloading URL"), url.absoluteString))
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120.0)
                // TODO: Progress Updates
                let (tempURL, response) = try await URLSession.shared.download(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw RegistryManagerError.downloadFailed(
                        url: url,
                        error: NSError(domain: String(localized: "github.download.error.http", defaultValue: "HTTP error", comment: "HTTP error domain"), code: (response as? HTTPURLResponse)?.statusCode ?? -1)
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
                        error: NSError(domain: String(localized: "github.download.error.failed", defaultValue: "Could not download package", comment: "Error when package download fails"), code: -1)
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
            name: String(localized: "github.decompress.title", defaultValue: "Decompress Binary Executable", comment: "Title for decompression step"),
            confirmation: .none,
        ) { model in
            let fileName = url.lastPathComponent
            let downloadPath = installationDirectory.appending(path: source.entryName)
            let packagePath = downloadPath.appending(path: fileName)

            if packagePath.pathExtension == String(localized: "github.decompress.ext.tar", defaultValue: "tar", comment: "Tar file extension") || packagePath.pathExtension == String(localized: "github.decompress.ext.zip", defaultValue: ".zip", comment: "Zip file extension") {
                await model.status(String(format: String(localized: "github.decompress.status", defaultValue: "Decompressing %@", comment: "Status message for decompressing file"), fileName))
                try await FileManager.default.unzipItem(at: packagePath, to: downloadPath, progress: model.progress)
                if FileManager.default.fileExists(atPath: packagePath.path(percentEncoded: false)) {
                    try FileManager.default.removeItem(at: packagePath)
                }
                await model.status(String(format: String(localized: "github.decompress.status.complete", defaultValue: "Decompressed to '%@'", comment: "Status message for completed decompression"), downloadPath.path(percentEncoded: false)))
            } else if packagePath.lastPathComponent.hasSuffix(String(localized: "github.decompress.ext.tar-gz", defaultValue: ".tar.gz", comment: "Tar.gz file extension")) {
                await model.status(String(format: String(localized: "github.decompress.status.tar", defaultValue: "Decompressing %@ using `tar`", comment: "Status message for tar decompression"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        String(localized: "github.decompress.cmd.tar", defaultValue: "tar", comment: "Tar command"),
                        String(localized: "github.decompress.cmd.tar-flags", defaultValue: "-xzf", comment: "Tar extraction flags"),
                        packagePath.path(percentEncoded: false).escapedDirectory(),
                    ]
                )
            } else if packagePath.pathExtension == String(localized: "github.decompress.ext.gz", defaultValue: "gz", comment: "Gzip file extension") {
                await model.status(String(format: String(localized: "github.decompress.status.gunzip", defaultValue: "Decompressing %@ using `gunzip`", comment: "Status message for gunzip decompression"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        String(localized: "github.decompress.cmd.gunzip", defaultValue: "gunzip", comment: "Gunzip command"),
                        String(localized: "github.decompress.cmd.gunzip-flags", defaultValue: "-f", comment: "Gunzip force flag"),
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
        let command = [String(localized: "github.git.cmd.git", defaultValue: "git", comment: "Git command"), String(localized: "github.git.cmd.clone", defaultValue: "clone", comment: "Git clone subcommand"), repoURL]

        return PackageManagerInstallStep(
            name: String(localized: "github.git.title", defaultValue: "Clone with Git", comment: "Title for git clone step"),
            // swiftlint:disable:next line_length
            confirmation: .required(message: String(format: String(localized: "github.git.confirmation", defaultValue: "This step will run the following command to clone the package from source control:\n`%@`", comment: "Confirmation message for git clone command"), command.joined(separator: " ")))
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
            name: String(localized: "github.source.title", defaultValue: "Install From Source", comment: "Title for source installation step"),
            confirmation: .required(message: String(format: String(localized: "github.source.confirmation", defaultValue: "This step will run the following to finish installing:\n`%@`", comment: "Confirmation message for source installation command"), command))
        ) { model in
            do {
                let installPath = installationDirectory.appending(path: source.entryName, directoryHint: .isDirectory)
                let repoPath = installPath.appending(path: source.pkgName, directoryHint: .isDirectory)
                _ = try await model.executeInDirectory(in: repoPath.path, [command])
            } catch {
                throw PackageManagerError.installationFailed(String(localized: "github.source.error.failed", defaultValue: "Source build failed.", comment: "Error message when source build fails"))
            }
        }
    }
}
