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
                    message: String(
                        localized: "github-package-manager.git-permission",
                        defaultValue: "This package requires git to install. Allow CodeEdit to run git commands?",
                        comment: "Confirmation message asking permission to run git commands"
                    )
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
            name: String(
                localized: "github-package-manager.step.initialize",
                defaultValue: "Initialize Directory Structure",
                comment: "Install step name for initializing directory structure"
            ),
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
            name: String(
                localized: "github-package-manager.step.download-binary",
                defaultValue: "Download Binary Executable",
                comment: "Install step name for downloading binary executable"
            ),
            confirmation: .none
        ) { model in
            do {
                let urlString = "\(url)"
                await model.status(String(
                    localized: "github-package-manager.status.downloading",
                    defaultValue: "Downloading \(urlString)",
                    comment: "Status message while downloading a file"
                ))
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120.0)
                // TODO: Progress Updates
                let (tempURL, response) = try await URLSession.shared.download(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw RegistryManagerError.downloadFailed(
                        url: url,
                        error: NSError(domain: "HTTP error", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
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
                        error: NSError(domain: "Could not download package", code: -1)
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
            name: String(
                localized: "github-package-manager.step.decompress-binary",
                defaultValue: "Decompress Binary Executable",
                comment: "Install step name for decompressing binary executable"
            ),
            confirmation: .none,
        ) { model in
            let fileName = url.lastPathComponent
            let downloadPath = installationDirectory.appending(path: source.entryName)
            let packagePath = downloadPath.appending(path: fileName)

            if packagePath.pathExtension == "tar" || packagePath.pathExtension == ".zip" {
                await model.status(String(
                    localized: "github-package-manager.status.decompressing",
                    defaultValue: "Decompressing \(fileName)",
                    comment: "Status message while decompressing a file"
                ))
                try await FileManager.default.unzipItem(at: packagePath, to: downloadPath, progress: model.progress)
                if FileManager.default.fileExists(atPath: packagePath.path(percentEncoded: false)) {
                    try FileManager.default.removeItem(at: packagePath)
                }
                let downloadPathString = downloadPath.path(percentEncoded: false)
                await model.status(String(
                    localized: "github-package-manager.status.decompressed-to",
                    defaultValue: "Decompressed to '\(downloadPathString)'",
                    comment: "Status message showing where files were decompressed"
                ))
            } else if packagePath.lastPathComponent.hasSuffix(".tar.gz") {
                await model.status(String(
                    localized: "github-package-manager.status.decompressing-tar",
                    defaultValue: "Decompressing \(fileName) using `tar`",
                    comment: "Status message while decompressing using tar"
                ))
                _ = try await model.executeInDirectory(
                    in: packagePath.deletingLastPathComponent().path(percentEncoded: false),
                    [
                        "tar",
                        "-xzf",
                        packagePath.path(percentEncoded: false).escapedDirectory(),
                    ]
                )
            } else if packagePath.pathExtension == "gz" {
                await model.status(String(
                    localized: "github-package-manager.status.decompressing-gunzip",
                    defaultValue: "Decompressing \(fileName) using `gunzip`",
                    comment: "Status message while decompressing using gunzip"
                ))
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
            name: String(
                localized: "github-package-manager.step.git-clone",
                defaultValue: "Clone with Git",
                comment: "Install step name for cloning repository with git"
            ),
            // swiftlint:disable:next line_length
            confirmation: .required(message: {
                let commandString = command.joined(separator: " ")
                return String(
                    localized: "github-package-manager.confirmation.git-clone",
                    defaultValue: "This step will run the following command to clone the package from source control:\n`\(commandString)`",
                    comment: "Confirmation message showing git clone command to be executed"
                )
            }())
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
            name: String(
                localized: "github-package-manager.step.install-from-source",
                defaultValue: "Install From Source",
                comment: "Install step name for building from source"
            ),
            confirmation: .required(message: String(
                localized: "github-package-manager.confirmation.install-from-source",
                defaultValue: "This step will run the following to finish installing:\n`\(command)`",
                comment: "Confirmation message showing build command to be executed"
            ))
        ) { model in
            do {
                let installPath = installationDirectory.appending(path: source.entryName, directoryHint: .isDirectory)
                let repoPath = installPath.appending(path: source.pkgName, directoryHint: .isDirectory)
                _ = try await model.executeInDirectory(in: repoPath.path, [command])
            } catch {
                throw PackageManagerError.installationFailed(String(
                    localized: "github-package-manager.error.source-build-failed",
                    defaultValue: "Source build failed.",
                    comment: "Error message when source build fails"
                ))
            }
        }
    }
}
