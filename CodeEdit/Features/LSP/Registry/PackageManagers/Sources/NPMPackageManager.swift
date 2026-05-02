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
                message: String(localized: "npm.package.install.confirmation", defaultValue: "This package requires npm to install. Allow CodeEdit to run npm commands?", comment: "Confirmation message for allowing npm commands")
            )
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "npm.version.command", defaultValue: "npm --version", comment: "NPM version command"))
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
            .appending(path: String(localized: "npm.node.modules.directory", defaultValue: "node_modules", comment: "Node modules directory name"))
            .appending(path: String(localized: "npm.bin.directory", defaultValue: ".bin", comment: "Binary directory name"))
        return binDirectory.appending(path: package).path
    }

    // MARK: - Initialize

    /// Initializes the npm project if not already initialized
    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "npm.initialize.step.name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            // Clean existing files
            let pkgJson = packagePath.appending(path: String(localized: "npm.package.json.filename", defaultValue: "package.json", comment: "Package.json filename"))
            if FileManager.default.fileExists(atPath: pkgJson.path) {
                try FileManager.default.removeItem(at: pkgJson)
            }
            let pkgLockJson = packagePath.appending(path: String(localized: "npm.package.lock.json.filename", defaultValue: "package-lock.json", comment: "Package-lock.json filename"))
            if FileManager.default.fileExists(atPath: pkgLockJson.path) {
                try FileManager.default.removeItem(at: pkgLockJson)
            }

            // Init npm directory with .npmrc file
            try await model.createDirectoryStructure(for: packagePath)
            _ = try await model.executeInDirectory(
                in: packagePath.path, [String(localized: "npm.init.command", defaultValue: "npm init --yes --scope=codeedit", comment: "NPM init command")]
            )

            let npmrcPath = packagePath.appending(path: String(localized: "npm.npmrc.filename", defaultValue: ".npmrc", comment: "NPM config filename"))
            if !FileManager.default.fileExists(atPath: npmrcPath.path) {
                try String(localized: "npm.install.strategy.shallow", defaultValue: "install-strategy=shallow", comment: "NPM install strategy config").write(to: npmrcPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - NPM Install

    func runNpmInstall(_ source: PackageSource, installDir installationDirectory: URL) -> PackageManagerInstallStep {
        let qualifiedSourceName = String(format: String(localized: "npm.package.version.format", defaultValue: "%@@%@", comment: "Package version format"), source.pkgName, source.version)
        let otherPackages = source.options[String(localized: "npm.extra.packages.option", defaultValue: "extraPackages", comment: "Extra packages option key")]?
            .split(separator: Character(String(localized: "npm.comma.separator", defaultValue: ",", comment: "Comma separator")))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        var packageList = ([qualifiedSourceName] + otherPackages)

        // FIXME: This will break with localization. Use real Foundation APIs for pluralizing lists.
        let plural = packageList.count > 1
        if plural, var last = packageList.last {
            // Oxford comma
            last = "and " + last
            packageList[packageList.count - 1] = last
        }
        let packagesDescription = packageList.joined(separator: String(localized: "npm.comma.space.separator", defaultValue: ", ", comment: "Comma and space separator"))

        let sSuffix = packageList.count > 1 ? String(localized: "npm.plural.s.suffix", defaultValue: "s", comment: "Plural s suffix") : ""
        let suffix = plural ? String(localized: "npm.these.packages", defaultValue: "these packages", comment: "These packages") : String(localized: "npm.this.package", defaultValue: "this package", comment: "This package")

        return PackageManagerInstallStep(
            name: String(localized: "npm.install.step.name", defaultValue: "Install Package Using npm", comment: "Installation step name for installing package using npm"),
            confirmation: .required(
                message: String(format: String(localized: "npm.install.confirmation", defaultValue: "This requires the npm package%@ %@.\nAllow CodeEdit to install %@?", comment: "Confirmation message for installing npm package"), sSuffix, packagesDescription, suffix)
            )
        ) { model in
            do {
                var installArgs = [String(localized: "npm.command", defaultValue: "npm", comment: "NPM command"), String(localized: "npm.install.subcommand", defaultValue: "install", comment: "Install subcommand"), qualifiedSourceName]
                if let dev = source.options[String(localized: "npm.dev.option", defaultValue: "dev", comment: "Dev option key")], dev.lowercased() == String(localized: "npm.true.value", defaultValue: "true", comment: "True value") {
                    installArgs.append(String(localized: "npm.save.dev.flag", defaultValue: "--save-dev", comment: "Save dev flag"))
                }
                for extraPackage in otherPackages {
                    installArgs.append(extraPackage)
                }

                _ = try await model.executeInDirectory(
                    in: installationDirectory.path(percentEncoded: false),
                    installArgs
                )
            } catch {
                let nodeModulesPath = installationDirectory.appending(path: String(localized: "npm.node.modules.directory.2", defaultValue: "node_modules", comment: "Node modules directory name")).path(percentEncoded: false)
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
            name: String(localized: "npm.verify.step.name", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { _ in
            let packageJsonPath = packagePath.appending(path: String(localized: "npm.package.json.filename.2", defaultValue: "package.json", comment: "Package.json filename")).path

            // Verify package.json contains the installed package
            guard let packageJsonData = FileManager.default.contents(atPath: packageJsonPath),
                  let packageJson = try? JSONSerialization.jsonObject(with: packageJsonData, options: []),
                  let packageDict = packageJson as? [String: Any],
                  let dependencies = packageDict[String(localized: "npm.dependencies.key", defaultValue: "dependencies", comment: "Dependencies key")] as? [String: String],
                  let installedVersion = dependencies[package] else {
                throw PackageManagerError.installationFailed(String(localized: "npm.error.package.not.found.in.json", defaultValue: "Package not found in package.json", comment: "Error message when package is not found in package.json"))
            }

            // Verify installed version matches requested version
            let normalizedInstalledVersion = installedVersion.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm.version.prefix.chars", defaultValue: "^~", comment: "Version prefix characters")))
            let normalizedRequestedVersion = version.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm.version.prefix.chars.2", defaultValue: "^~", comment: "Version prefix characters")))
            if normalizedInstalledVersion != normalizedRequestedVersion &&
                !installedVersion.contains(normalizedRequestedVersion) {
                throw PackageManagerError.installationFailed(
                    String(format: String(localized: "npm.error.version.mismatch", defaultValue: "Version mismatch: Expected %@, but found %@", comment: "Error message for version mismatch"), version, installedVersion)
                )
            }

            // Verify the package exists in node_modules
            let packageDirectory = packagePath
                .appending(path: String(localized: "npm.node.modules.directory.3", defaultValue: "node_modules", comment: "Node modules directory name"))
                .appending(path: package)
            guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
                throw PackageManagerError.installationFailed(String(localized: "npm.error.package.not.found.in.modules", defaultValue: "Package not found in node_modules", comment: "Error message when package is not found in node_modules"))
            }
        }
    }
}
