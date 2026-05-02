//
//  GolangPackageManager.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/3/25.
//

import Foundation

final class GolangPackageManager: PackageManagerProtocol {
    private let installationDirectory: URL

    let shellClient: ShellClient

    init(installationDirectory: URL) {
        self.installationDirectory = installationDirectory
        self.shellClient = .live()
    }

    // MARK: - PackageManagerProtocol

    func install(method installationMethod: InstallationMethod) throws -> [PackageManagerInstallStep] {
        guard case .standardPackage(let source) = installationMethod else {
            throw PackageManagerError.invalidConfiguration
        }

        let packagePath = installationDirectory.appending(path: source.entryName)
        var steps = [
            initialize(in: packagePath),
            runGoInstall(source, packagePath: packagePath)
        ]

        if source.options[String(localized: "golang-pm.option.subpath-key", defaultValue: "subpath", comment: "Options dictionary key for package subpath")] != nil {
            steps.append(buildBinary(source, packagePath: packagePath))
        }

        return steps
    }

    /// Check if go is installed
    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: "",
            confirmation: .required(message: String(localized: "golang-pm.confirmation.go-commands", defaultValue: "This package requires go to install. Allow CodeEdit to run go commands?", comment: "Confirmation message to allow running go commands"))
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "golang-pm.command.go-version", defaultValue: "go version", comment: "Command to check go version"))
            let versionPattern = #"go version go\d+\.\d+"#
            let output = versionOutput.reduce(into: "") {
                $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            guard output.range(of: versionPattern, options: .regularExpression) != nil else {
                throw PackageManagerError.packageManagerNotInstalled
            }
        }
    }

    /// Get the binary path for a Go package
    func getBinaryPath(for package: String) -> String {
        let binPath = installationDirectory.appending(path: package).appending(path: String(localized: "golang-pm.dir.bin", defaultValue: "bin", comment: "Binary directory name"))
        let binaryName = package.components(separatedBy: String(localized: "golang-pm.separator.slash", defaultValue: "/", comment: "Path separator character")).last ?? package
        let specificBinPath = binPath.appending(path: binaryName).path
        if FileManager.default.fileExists(atPath: specificBinPath) {
            return specificBinPath
        }
        return binPath.path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "golang-pm.step.initialize", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"),
            confirmation: .none
        ) { model in
            try await model.createDirectoryStructure(for: packagePath)

            // For Go, we need to set up a proper module structure
            let goModPath = packagePath.appending(path: String(localized: "golang-pm.file.go-mod", defaultValue: "go.mod", comment: "Go module file name"))
            if !FileManager.default.fileExists(atPath: goModPath.path) {
                let moduleName = String(localized: "golang-pm.module.placeholder", defaultValue: "codeedit.temp/placeholder", comment: "Placeholder module name for temporary Go modules")
                _ = try await model.executeInDirectory(
                    in: packagePath.path, [String(format: String(localized: "golang-pm.command.mod-init", defaultValue: "go mod init %@", comment: "Command to initialize Go module"), moduleName)]
                )
            }
        }
    }

    // MARK: - Install Using Go

    func runGoInstall(_ source: PackageSource, packagePath: URL) -> PackageManagerInstallStep {
        let installCommand = getGoInstallCommand(source)
        return PackageManagerInstallStep(
            name: String(localized: "golang-pm.step.install", defaultValue: "Install Package Using go", comment: "Installation step name for installing package with go"),
            confirmation: .required(
                message: String(format: String(localized: "golang-pm.confirmation.install-package", defaultValue: "This requires installing the go package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message to install go package"), installCommand)
            )
        ) { model in
            let gobinPath = packagePath.appending(path: String(localized: "golang-pm.dir.bin-install", defaultValue: "bin", comment: "Binary directory name for installation"), directoryHint: .isDirectory).path
            var goInstallCommand = [String(localized: "golang-pm.command.env", defaultValue: "env", comment: "env command"), String(format: String(localized: "golang-pm.env.gobin", defaultValue: "GOBIN=%@", comment: "GOBIN environment variable"), gobinPath), String(localized: "golang-pm.command.go", defaultValue: "go", comment: "go command"), String(localized: "golang-pm.command.install", defaultValue: "install", comment: "install subcommand")]

            goInstallCommand.append(installCommand)
            _ = try await model.executeInDirectory(in: packagePath.path, goInstallCommand)
        }
    }

    // MARK: - Build Binary

    func buildBinary(_ source: PackageSource, packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "golang-pm.step.build", defaultValue: "Build From Source", comment: "Installation step name for building from source"),
            confirmation: .none
        ) { model in
            // If there's a subpath, build the binary
            if let subpath = source.options[String(localized: "golang-pm.option.subpath-build", defaultValue: "subpath", comment: "Options dictionary key for build subpath")] {
                let binPath = packagePath.appending(path: String(localized: "golang-pm.dir.bin-build", defaultValue: "bin", comment: "Binary directory name for building"))
                if !FileManager.default.fileExists(atPath: binPath.path) {
                    try FileManager.default.createDirectory(at: binPath, withIntermediateDirectories: true)
                }

                let binaryName = subpath.components(separatedBy: String(localized: "golang-pm.separator.slash-build", defaultValue: "/", comment: "Path separator for build")).last ??
                source.pkgName.components(separatedBy: String(localized: "golang-pm.separator.slash-pkg-name", defaultValue: "/", comment: "Path separator for package name")).last ?? source.pkgName
                let buildArgs = [String(localized: "golang-pm.command.go-build", defaultValue: "go", comment: "go command for building"), String(localized: "golang-pm.command.build", defaultValue: "build", comment: "build subcommand"), String(localized: "golang-pm.arg.output", defaultValue: "-o", comment: "Output flag for go build"), String(format: String(localized: "golang-pm.path.bin-output", defaultValue: "bin/%@", comment: "Output path for binary"), binaryName)]

                // If source.pkgName includes the full import path (like github.com/owner/repo)
                if source.pkgName.contains(String(localized: "golang-pm.separator.slash-contains", defaultValue: "/", comment: "Path separator for checking package name")) {
                    _ = try await model.executeInDirectory(
                        in: packagePath.path, buildArgs + [String(format: String(localized: "golang-pm.path.pkg-subpath", defaultValue: "%@/%@", comment: "Package name with subpath"), source.pkgName, subpath)]
                    )
                } else {
                    _ = try await model.executeInDirectory(
                        in: packagePath.path, buildArgs + [subpath]
                    )
                }
                let execPath = packagePath.appending(path: String(localized: "golang-pm.dir.bin-exec", defaultValue: "bin", comment: "Binary directory name for executable")).appending(path: binaryName)
                try FileManager.default.makeExecutable(execPath)
            }
        }
    }

    // MARK: - Helper methods

    /// Clean up after a failed installation
    private func cleanupFailedInstallation(packagePath: URL) throws {
        let goSumPath = packagePath.appending(path: String(localized: "golang-pm.file.go-sum", defaultValue: "go.sum", comment: "Go checksum file name"))
        if FileManager.default.fileExists(atPath: goSumPath.path) {
            try FileManager.default.removeItem(at: goSumPath)
        }
    }

    private func getGoInstallCommand(_ source: PackageSource) -> String {
        if let gitRef = source.gitReference, let repoUrl = source.repositoryUrl {
            // Check if this is a Git-based package
            var packageName = source.pkgName
            if !packageName.contains(String(localized: "golang-pm.domain.github", defaultValue: "github.com", comment: "GitHub domain name")) && !packageName.contains(String(localized: "golang-pm.domain.golang", defaultValue: "golang.org", comment: "Golang domain name")) {
                packageName = repoUrl.replacingOccurrences(of: String(localized: "golang-pm.protocol.https", defaultValue: "https://", comment: "HTTPS protocol prefix"), with: "")
            }

            var gitVersion: String
            switch gitRef {
            case .tag(let tag):
                gitVersion = tag
            case .revision(let rev):
                gitVersion = rev
            }

            return String(format: String(localized: "golang-pm.format.package-version", defaultValue: "%@@%@", comment: "Package name with version"), packageName, gitVersion)
        } else {
            return String(format: String(localized: "golang-pm.format.package-version-default", defaultValue: "%@@%@", comment: "Package name with version (default)"), source.pkgName, source.version)
        }
    }
}
