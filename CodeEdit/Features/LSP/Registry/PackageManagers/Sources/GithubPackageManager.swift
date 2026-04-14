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
                    message: String(localized: "package.git-required", defaultValue: "This package requires git to install. Allow CodeEdit to run git commands?", comment: "Git permission request message", os_id: "102100")
                )
            ) { model in
                let versionOutput = try await model.runCommand("git --version")
                let output = versionOutput.reduce(into: "") {
                    $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                guard output.contains("git version") else {
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
        return installationDirectory.appending(path: package).appending(path: "bin").path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "package.initialize-directory-structure", defaultValue: "Initialize Directory Structure", comment: "Initialize directory structure step name"),
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
            name: String(localized: "package.download-binary-executable", defaultValue: "Download Binary Executable", comment: "Download binary executable step name", os_id: "102101"),
            confirmation: .none
        ) { model in
            do {
                await model.status(String(format: String(localized: "package.downloading-url", defaultValue: "Downloading %@", comment: "Downloading status message", os_id: "102102"), url.absoluteString))
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120.0)
                // TODO: Progress Updates
                let (tempURL, response) = try await URLSession.shared.download(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw RegistryManagerError.downloadFailed(
                        url: url,
                        error: NSError(domain: String(localized: "package.http-error", defaultValue: "HTTP error", comment: "HTTP error domain", os_id: "102103"), code: (response as? HTTPURLResponse)?.statusCode ?? -1)
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
                        error: NSError(domain: String(localized: "package.could-not-download", defaultValue: "Could not download package", comment: "Download error domain", os_id: "102104"), code: -1)
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
            name: String(localized: "package.decompress-binary-executable", defaultValue: "Decompress Binary Executable", comment: "Decompress binary executable step name", os_id: "102105"),
            confirmation: .none,
        ) { model in
            let fileName = url.lastPathComponent
            let downloadPath = installationDirectory.appending(path: source.entryName)
            let packagePath = downloadPath.appending(path: fileName)

            if packagePath.pathExtension == "tar" || packagePath.pathExtension == ".zip" {
                await model.status(String(format: String(localized: "package.decompressing-filename", defaultValue: "Decompressing %@", comment: "Decompressing status message", os_id: "102106"), fileName))
                try await FileManager.default.unzipItem(at: packagePath, to: downloadPath, progress: model.progress)
                if FileManager.default.fileExists(atPath: packagePath.path(percentEncoded: false)) {
                    try FileManager.default.removeItem(at: packagePath)
                }
                await model.status(String(format: String(localized: "package.decompressed-to-path", defaultValue: "Decompressed to '%@'", comment: "Decompressed to path status message", os_id: "102107"), downloadPath.path(percentEncoded: false)))
            } else if packagePath.lastPathComponent.hasSuffix(".tar.gz") {
                await model.status(String(format: String(localized: "package.decompressing-filename-tar", defaultValue: "Decompressing %@ using `tar`", comment: "Decompressing with tar status message", os_id: "102108"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        "tar",
                        "-xzf",
                        packagePath.path(percentEncoded: false).escapedDirectory(),
                    ]
                )
            } else if packagePath.pathExtension == "gz" {
                await model.status(String(format: String(localized: "package.decompressing-filename-gunzip", defaultValue: "Decompressing %@ using `gunzip`", comment: "Decompressing with gunzip status message", os_id: "102109"), fileName))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        "gunzip",
                        "-f",
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
            name: String(localized: "package.clone-with-git", defaultValue: "Clone with Git", comment: "Clone with git step name", os_id: "102110"),
            // swiftlint:disable:next line_length
            confirmation: .required(message: String(format: String(localized: "package.git-clone-confirmation", defaultValue: "This step will run the following command to clone the package from source control:\n`%@`", comment: "Git clone confirmation message", os_id: "102111"), command.joined(separator: " ")))
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
            name: String(localized: "package.install-from-source", defaultValue: "Install From Source", comment: "Install from source step name", os_id: "102112"),
            confirmation: .required(message: String(format: String(localized: "package.install-confirmation", defaultValue: "This step will run the following to finish installing:\n`%@`", comment: "Install confirmation message", os_id: "102113"), command))
        ) { model in
            do {
                let installPath = installationDirectory.appending(path: source.entryName, directoryHint: .isDirectory)
                let repoPath = installPath.appending(path: source.pkgName, directoryHint: .isDirectory)
                _ = try await model.executeInDirectory(in: repoPath.path, [command])
            } catch {
                throw PackageManagerError.installationFailed(String(localized: "package.source-build-failed", defaultValue: "Source build failed.", comment: "Source build failed error message", os_id: "102114"))
            }
        }
    }
}
