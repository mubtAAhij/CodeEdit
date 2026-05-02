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
                message: String(localized: "npm-pm.confirmation.npm-commands", defaultValue: "This package requires npm to install. Allow CodeEdit to run npm commands?", comment: "Confirmation message to allow running npm commands")
            )
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "npm-pm.command.npm-version", defaultValue: "npm --version", comment: "Command to check npm version"))
            let versionPattern = #"^\d+\.\d+\.\d+$"#
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
            .appending(path: String(localized: "npm-pm.dir.node-modules", defaultValue: "node_modules", comment: "Node modules directory name"))
            .appending(path: String(localized: "npm-pm.dir.bin", defaultValue: ".bin", comment: "Binary directory name"))
        return binDirectory.appending(path: package).path
    }

    // MARK: - Initialize

    /// Initializes the npm project if not already initialized
    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "npm-pm.step.initialize", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            // Clean existing files
            let pkgJson = packagePath.appending(path: String(localized: "npm-pm.file.package-json", defaultValue: "package.json", comment: "NPM package file name"))
            if FileManager.default.fileExists(atPath: pkgJson.path) {
                try FileManager.default.removeItem(at: pkgJson)
            }
            let pkgLockJson = packagePath.appending(path: String(localized: "npm-pm.file.package-lock-json", defaultValue: "package-lock.json", comment: "NPM package lock file name"))
            if FileManager.default.fileExists(atPath: pkgLockJson.path) {
                try FileManager.default.removeItem(at: pkgLockJson)
            }

            // Init npm directory with .npmrc file
            try await model.createDirectoryStructure(for: packagePath)
            _ = try await model.executeInDirectory(
                in: packagePath.path, [String(localized: "npm-pm.command.npm-init", defaultValue: "npm init --yes --scope=codeedit", comment: "Command to initialize NPM package")]
            )

            let npmrcPath = packagePath.appending(path: String(localized: "npm-pm.file.npmrc", defaultValue: ".npmrc", comment: "NPM configuration file name"))
            if !FileManager.default.fileExists(atPath: npmrcPath.path) {
                try String(localized: "npm-pm.config.install-strategy", defaultValue: "install-strategy=shallow", comment: "NPM install strategy configuration").write(to: npmrcPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - NPM Install

    func runNpmInstall(_ source: PackageSource, installDir installationDirectory: URL) -> PackageManagerInstallStep {
        let qualifiedSourceName = String(format: String(localized: "npm-pm.format.package-version", defaultValue: "%@@%@", comment: "Package name with version"), source.pkgName, source.version)
        let otherPackages = source.options[String(localized: "npm-pm.option.extra-packages", defaultValue: "extraPackages", comment: "Extra packages option key")]?
            .split(separator: Character(String(localized: "npm-pm.separator.comma", defaultValue: ",", comment: "Comma separator")))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        var packageList = ([qualifiedSourceName] + otherPackages)

        // FIXME: This will break with localization. Use real Foundation APIs for pluralizing lists.
        let plural = packageList.count > 1
        if plural, var last = packageList.last {
            // Oxford comma
            last = "and " + last
            packageList[packageList.count - 1] = last
        }
        let packagesDescription = packageList.joined(separator: String(localized: "npm-pm.separator.comma-space", defaultValue: ", ", comment: "Comma-space separator for lists"))

        let sSuffix = packageList.count > 1 ? String(localized: "npm-pm.plural.s", defaultValue: "s", comment: "Plural suffix for package") : ""
        let suffix = plural ? String(localized: "npm-pm.plural.these-packages", defaultValue: "these packages", comment: "Plural form for packages") : String(localized: "npm-pm.singular.this-package", defaultValue: "this package", comment: "Singular form for package")

        return PackageManagerInstallStep(
            name: String(localized: "npm-pm.step.install", defaultValue: "Install Package Using npm", comment: "Installation step name for installing package with npm"),
            confirmation: .required(
                message: String(format: String(localized: "npm-pm.confirmation.install-package", defaultValue: "This requires the npm package%@ %@.\nAllow CodeEdit to install %@?", comment: "Confirmation message to install npm package"), sSuffix, packagesDescription, suffix)
            )
        ) { model in
            do {
                var installArgs = [String(localized: "npm-pm.command.npm", defaultValue: "npm", comment: "npm command"), String(localized: "npm-pm.command.install", defaultValue: "install", comment: "install subcommand"), qualifiedSourceName]
                if let dev = source.options[String(localized: "npm-pm.option.dev", defaultValue: "dev", comment: "dev option key")], dev.lowercased() == String(localized: "npm-pm.value.true", defaultValue: "true", comment: "true value") {
                    installArgs.append(String(localized: "npm-pm.arg.save-dev", defaultValue: "--save-dev", comment: "Save as dev dependency argument"))
                }
                for extraPackage in otherPackages {
                    installArgs.append(extraPackage)
                }

                _ = try await model.executeInDirectory(
                    in: installationDirectory.path(percentEncoded: false),
                    installArgs
                )
            } catch {
                let nodeModulesPath = installationDirectory.appending(path: String(localized: "npm-pm.dir.node-modules-cleanup", defaultValue: "node_modules", comment: "Node modules directory name for cleanup")).path(percentEncoded: false)
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
            name: String(localized: "npm-pm.step.verify", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { _ in
            let packageJsonPath = packagePath.appending(path: String(localized: "npm-pm.file.package-json-verify", defaultValue: "package.json", comment: "NPM package file name for verification")).path

            // Verify package.json contains the installed package
            guard let packageJsonData = FileManager.default.contents(atPath: packageJsonPath),
                  let packageJson = try? JSONSerialization.jsonObject(with: packageJsonData, options: []),
                  let packageDict = packageJson as? [String: Any],
                  let dependencies = packageDict[String(localized: "npm-pm.key.dependencies", defaultValue: "dependencies", comment: "Dependencies key in package.json")] as? [String: String],
                  let installedVersion = dependencies[package] else {
                throw PackageManagerError.installationFailed(String(localized: "npm-pm.error.package-not-found-json", defaultValue: "Package not found in package.json", comment: "Error when package not found in package.json"))
            }

            // Verify installed version matches requested version
            let normalizedInstalledVersion = installedVersion.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm-pm.chars.version-prefix", defaultValue: "^~", comment: "Version prefix characters to trim")))
            let normalizedRequestedVersion = version.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm-pm.chars.version-prefix-requested", defaultValue: "^~", comment: "Version prefix characters to trim for requested version")))
            if normalizedInstalledVersion != normalizedRequestedVersion &&
                !installedVersion.contains(normalizedRequestedVersion) {
                throw PackageManagerError.installationFailed(
                    String(format: String(localized: "npm-pm.error.version-mismatch", defaultValue: "Version mismatch: Expected %@, but found %@", comment: "Error when installed version doesn't match"), version, installedVersion)
                )
            }

            // Verify the package exists in node_modules
            let packageDirectory = packagePath
                .appending(path: String(localized: "npm-pm.dir.node-modules-verify", defaultValue: "node_modules", comment: "Node modules directory name for verification"))
                .appending(path: package)
            guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
                throw PackageManagerError.installationFailed(String(localized: "npm-pm.error.package-not-found-modules", defaultValue: "Package not found in node_modules", comment: "Error when package not found in node_modules"))
            }
        }
    }
}
