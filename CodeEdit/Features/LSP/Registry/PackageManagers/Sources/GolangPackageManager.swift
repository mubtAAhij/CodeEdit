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

        if source.options[String(localized: "golang.package.option.subpath", defaultValue: "subpath", comment: "Package option key for subpath")] != nil {
            steps.append(buildBinary(source, packagePath: packagePath))
        }

        return steps
    }

    /// Check if go is installed
    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: "",
            confirmation: .required(message: String(localized: "golang.package.install.confirmation", defaultValue: "This package requires go to install. Allow CodeEdit to run go commands?", comment: "Confirmation message for allowing go commands"))
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "golang.version.command", defaultValue: "go version", comment: "Go version command"))
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
        let binPath = installationDirectory.appending(path: package).appending(path: String(localized: "golang.bin.directory", defaultValue: "bin", comment: "Binary directory name"))
        let binaryName = package.components(separatedBy: String(localized: "golang.path.separator", defaultValue: "/", comment: "Path separator")).last ?? package
        let specificBinPath = binPath.appending(path: binaryName).path
        if FileManager.default.fileExists(atPath: specificBinPath) {
            return specificBinPath
        }
        return binPath.path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "golang.initialize.step.name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"),
            confirmation: .none
        ) { model in
            try await model.createDirectoryStructure(for: packagePath)

            // For Go, we need to set up a proper module structure
            let goModPath = packagePath.appending(path: String(localized: "golang.go.mod.filename", defaultValue: "go.mod", comment: "Go module filename"))
            if !FileManager.default.fileExists(atPath: goModPath.path) {
                let moduleName = String(localized: "golang.temp.module.name", defaultValue: "codeedit.temp/placeholder", comment: "Temporary module name for Go initialization")
                _ = try await model.executeInDirectory(
                    in: packagePath.path, [String(format: String(localized: "golang.mod.init.command", defaultValue: "go mod init %@", comment: "Go module init command"), moduleName)]
                )
            }
        }
    }

    // MARK: - Install Using Go

    func runGoInstall(_ source: PackageSource, packagePath: URL) -> PackageManagerInstallStep {
        let installCommand = getGoInstallCommand(source)
        return PackageManagerInstallStep(
            name: String(localized: "golang.install.step.name", defaultValue: "Install Package Using go", comment: "Installation step name for installing package using go"),
            confirmation: .required(
                message: String(format: String(localized: "golang.install.confirmation", defaultValue: "This requires installing the go package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message for installing go package"), installCommand)
            )
        ) { model in
            let gobinPath = packagePath.appending(path: String(localized: "golang.bin.directory.2", defaultValue: "bin", comment: "Binary directory name"), directoryHint: .isDirectory).path
            var goInstallCommand = [String(localized: "golang.env.command", defaultValue: "env", comment: "Environment command"), String(format: String(localized: "golang.gobin.env.var", defaultValue: "GOBIN=%@", comment: "GOBIN environment variable"), gobinPath), String(localized: "golang.go.command", defaultValue: "go", comment: "Go command"), String(localized: "golang.install.command", defaultValue: "install", comment: "Install command")]

            goInstallCommand.append(installCommand)
            _ = try await model.executeInDirectory(in: packagePath.path, goInstallCommand)
        }
    }

    // MARK: - Build Binary

    func buildBinary(_ source: PackageSource, packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: String(localized: "golang.build.step.name", defaultValue: "Build From Source", comment: "Installation step name for building from source"),
            confirmation: .none
        ) { model in
            // If there's a subpath, build the binary
            if let subpath = source.options[String(localized: "golang.package.option.subpath.2", defaultValue: "subpath", comment: "Package option key for subpath")] {
                let binPath = packagePath.appending(path: String(localized: "golang.bin.directory.3", defaultValue: "bin", comment: "Binary directory name"))
                if !FileManager.default.fileExists(atPath: binPath.path) {
                    try FileManager.default.createDirectory(at: binPath, withIntermediateDirectories: true)
                }

                let binaryName = subpath.components(separatedBy: String(localized: "golang.path.separator.2", defaultValue: "/", comment: "Path separator")).last ??
                source.pkgName.components(separatedBy: String(localized: "golang.path.separator.3", defaultValue: "/", comment: "Path separator")).last ?? source.pkgName
                let buildArgs = [String(localized: "golang.go.command.2", defaultValue: "go", comment: "Go command"), String(localized: "golang.build.command", defaultValue: "build", comment: "Build command"), String(localized: "golang.output.flag", defaultValue: "-o", comment: "Output flag"), String(format: String(localized: "golang.bin.output.path", defaultValue: "bin/%@", comment: "Binary output path"), binaryName)]

                // If source.pkgName includes the full import path (like github.com/owner/repo)
                if source.pkgName.contains(String(localized: "golang.path.separator.4", defaultValue: "/", comment: "Path separator")) {
                    _ = try await model.executeInDirectory(
                        in: packagePath.path, buildArgs + [String(format: String(localized: "golang.package.subpath.format", defaultValue: "%@/%@", comment: "Package subpath format"), source.pkgName, subpath)]
                    )
                } else {
                    _ = try await model.executeInDirectory(
                        in: packagePath.path, buildArgs + [subpath]
                    )
                }
                let execPath = packagePath.appending(path: String(localized: "golang.bin.directory.4", defaultValue: "bin", comment: "Binary directory name")).appending(path: binaryName)
                try FileManager.default.makeExecutable(execPath)
            }
        }
    }

    // MARK: - Helper methods

    /// Clean up after a failed installation
    private func cleanupFailedInstallation(packagePath: URL) throws {
        let goSumPath = packagePath.appending(path: String(localized: "golang.go.sum.filename", defaultValue: "go.sum", comment: "Go sum filename"))
        if FileManager.default.fileExists(atPath: goSumPath.path) {
            try FileManager.default.removeItem(at: goSumPath)
        }
    }

    private func getGoInstallCommand(_ source: PackageSource) -> String {
        if let gitRef = source.gitReference, let repoUrl = source.repositoryUrl {
            // Check if this is a Git-based package
            var packageName = source.pkgName
            if !packageName.contains(String(localized: "golang.github.domain", defaultValue: "github.com", comment: "GitHub domain")) && !packageName.contains(String(localized: "golang.golang.org.domain", defaultValue: "golang.org", comment: "Golang.org domain")) {
                packageName = repoUrl.replacingOccurrences(of: String(localized: "golang.https.prefix", defaultValue: "https://", comment: "HTTPS prefix"), with: "")
            }

            var gitVersion: String
            switch gitRef {
            case .tag(let tag):
                gitVersion = tag
            case .revision(let rev):
                gitVersion = rev
            }

            return String(format: String(localized: "golang.package.version.format", defaultValue: "%@@%@", comment: "Package version format"), packageName, gitVersion)
        } else {
            return String(format: String(localized: "golang.package.version.format.2", defaultValue: "%@@%@", comment: "Package version format"), source.pkgName, source.version)
        }
    }
}
