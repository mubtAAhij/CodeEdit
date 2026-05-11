//
//  NPMPackageManager.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/2/25.
//

import Foundation

final class NPMPackageManager: PackageManagerProtocol {
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
        return [
            initialize(in: packagePath),
            runNpmInstall(source, installDir: packagePath),
            verifyInstallation(source, installDir: packagePath)
        ]

    }

    /// Checks if npm is installed
    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: "",
            confirmation: .required(
                message: String(localized: "npm.package-manager.requires-npm", defaultValue: "This package requires npm to install. Allow CodeEdit to run npm commands?", comment: "Confirmation message asking permission to run npm commands")
            )
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "npm.package-manager.npm-version-command", defaultValue: "npm --version", comment: "Command to check npm version"))
            let versionPattern = String(localized: "npm.package-manager.version-pattern", defaultValue: #"^\d+\.\d+\.\d+$"#, comment: "Regular expression pattern to match npm version")
            let output = versionOutput.reduce(into: "") {
                $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            guard output.range(of: versionPattern, options: .regularExpression) != nil else {
                throw PackageManagerError.packageManagerNotInstalled
            }
        }
    }

    /// Get the path to the binary
    func getBinaryPath(for package: String) -> String {
        let binDirectory = installationDirectory
            .appending(path: package)
            .appending(path: String(localized: "npm.package-manager.node-modules-directory", defaultValue: "node_modules", comment: "Node modules directory name"))
            .appending(path: String(localized: "npm.package-manager.bin-directory", defaultValue: ".bin", comment: "Binary directory name"))
        return binDirectory.appending(path: package).path
    }

    // MARK: - Initialize

    /// Initializes the npm project if not already initialized
    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "npm.package-manager.initialize-step", defaultValue: "Initialize Directory Structure", comment: "Step name for initializing directory structure"), confirmation: .none) { model in
            // Clean existing files
            let pkgJson = packagePath.appending(path: String(localized: "npm.package-manager.package-json-file", defaultValue: "package.json", comment: "Package JSON file name"))
            if FileManager.default.fileExists(atPath: pkgJson.path) {
                try FileManager.default.removeItem(at: pkgJson)
            }
            let pkgLockJson = packagePath.appending(path: String(localized: "npm.package-manager.package-lock-json-file", defaultValue: "package-lock.json", comment: "Package lock JSON file name"))
            if FileManager.default.fileExists(atPath: pkgLockJson.path) {
                try FileManager.default.removeItem(at: pkgLockJson)
            }

            // Init npm directory with .npmrc file
            try await model.createDirectoryStructure(for: packagePath)
            _ = try await model.executeInDirectory(
                in: packagePath.path, [String(localized: "npm.package-manager.npm-init-command", defaultValue: "npm init --yes --scope=codeedit", comment: "Command to initialize npm package")]
            )

            let npmrcPath = packagePath.appending(path: String(localized: "npm.package-manager.npmrc-file", defaultValue: ".npmrc", comment: "NPM configuration file name"))
            if !FileManager.default.fileExists(atPath: npmrcPath.path) {
                try String(localized: "npm.package-manager.install-strategy-config", defaultValue: "install-strategy=shallow", comment: "NPM install strategy configuration").write(to: npmrcPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - NPM Install

    func runNpmInstall(_ source: PackageSource, installDir installationDirectory: URL) -> PackageManagerInstallStep {
        let qualifiedSourceName = String(format: String(localized: "npm.package-manager.package-version-format", defaultValue: "%@@%@", comment: "Package version format"), source.pkgName, source.version)
        let otherPackages = source.options["extraPackages"]?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        let packageList = ([qualifiedSourceName] + otherPackages)
        let packagesDescription = ListFormatter().string(from: packageList) ?? packageList.joined(separator: ", ")

        let count = packageList.count
        return PackageManagerInstallStep(
            name: String(localized: "npm.package-manager.install-step", defaultValue: "Install Package Using npm", comment: "Step name for installing package using npm"),
            confirmation: .required(
                message: String(format: String(localized: "npm.package-manager.install-confirmation", defaultValue: "This requires installing %@.\nAllow CodeEdit to install?", comment: "Confirmation message for installing npm package"), packagesDescription)
            )
        ) { model in
            do {
                var installArgs = [String(localized: "npm.package-manager.npm-command", defaultValue: "npm", comment: "NPM command"), String(localized: "npm.package-manager.install-command", defaultValue: "install", comment: "Install subcommand"), qualifiedSourceName]
                if let dev = source.options["dev"], dev.lowercased() == String(localized: "npm.package-manager.true-value", defaultValue: "true", comment: "True value for dev option") {
                    installArgs.append(String(localized: "npm.package-manager.save-dev-flag", defaultValue: "--save-dev", comment: "Save as dev dependency flag"))
                }
                for extraPackage in otherPackages {
                    installArgs.append(extraPackage)
                }

                _ = try await model.executeInDirectory(
                    in: installationDirectory.path(percentEncoded: false),
                    installArgs
                )
            } catch {
                let nodeModulesPath = installationDirectory.appending(path: String(localized: "npm.package-manager.node-modules-directory", defaultValue: "node_modules", comment: "Node modules directory name")).path(percentEncoded: false)
                try? FileManager.default.removeItem(atPath: nodeModulesPath)
                throw error
            }
        }
    }

    // MARK: - Verify

    /// Verify the installation was successful
    private func verifyInstallation(
        _ source: PackageSource,
        installDir packagePath: URL
    ) -> PackageManagerInstallStep {
        let package = source.pkgName
        let version = source.version

        return PackageManagerInstallStep(
            name: String(localized: "npm.package-manager.verify-step", defaultValue: "Verify Installation", comment: "Step name for verifying installation"),
            confirmation: .none
        ) { _ in
            let packageJsonPath = packagePath.appending(path: String(localized: "npm.package-manager.package-json-file", defaultValue: "package.json", comment: "Package JSON file name")).path

            // Verify package.json contains the installed package
            guard let packageJsonData = FileManager.default.contents(atPath: packageJsonPath),
                  let packageJson = try? JSONSerialization.jsonObject(with: packageJsonData, options: []),
                  let packageDict = packageJson as? [String: Any],
                  let dependencies = packageDict["dependencies"] as? [String: String],
                  let installedVersion = dependencies[package] else {
                throw PackageManagerError.installationFailed(String(localized: "npm.package-manager.package-not-found-in-json", defaultValue: "Package not found in package.json", comment: "Error message when package is not found in package.json"))
            }

            // Verify installed version matches requested version
            let normalizedInstalledVersion = installedVersion.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm.package-manager.version-prefix-chars", defaultValue: "^~", comment: "Version prefix characters to trim")))
            let normalizedRequestedVersion = version.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm.package-manager.version-prefix-chars", defaultValue: "^~", comment: "Version prefix characters to trim")))
            if normalizedInstalledVersion != normalizedRequestedVersion &&
                !installedVersion.contains(normalizedRequestedVersion) {
                throw PackageManagerError.installationFailed(
                    String(format: String(localized: "npm.package-manager.version-mismatch", defaultValue: "Version mismatch: Expected %@, but found %@", comment: "Error message for version mismatch"), version, installedVersion)
                )
            }

            // Verify the package exists in node_modules
            let packageDirectory = packagePath
                .appending(path: String(localized: "npm.package-manager.node-modules-directory", defaultValue: "node_modules", comment: "Node modules directory name"))
                .appending(path: package)
            guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
                throw PackageManagerError.installationFailed(String(localized: "npm.package-manager.package-not-found-in-modules", defaultValue: "Package not found in node_modules", comment: "Error message when package is not found in node_modules"))
            }
        }
    }
}
