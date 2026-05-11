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
                message: String(localized: "npm-package-manager.npm-permission-prompt", defaultValue: "This package requires npm to install. Allow CodeEdit to run npm commands?", comment: "Permission prompt for running npm commands")
            )
        ) { model in
            let versionOutput = try await model.runCommand("npm --version")
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
            .appending(path: String(localized: "npm-package-manager.node-modules-dir", defaultValue: "node_modules", comment: "Node modules directory name"))
            .appending(path: String(localized: "npm-package-manager.bin-dir", defaultValue: ".bin", comment: "Binary directory name"))
        return binDirectory.appending(path: package).path
    }

    // MARK: - Initialize

    /// Initializes the npm project if not already initialized
    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "npm-package-manager.initialize-step-name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            // Clean existing files
            let pkgJson = packagePath.appending(path: String(localized: "npm-package-manager.package-json-file", defaultValue: "package.json", comment: "NPM package.json file name"))
            if FileManager.default.fileExists(atPath: pkgJson.path) {
                try FileManager.default.removeItem(at: pkgJson)
            }
            let pkgLockJson = packagePath.appending(path: String(localized: "npm-package-manager.package-lock-json-file", defaultValue: "package-lock.json", comment: "NPM package-lock.json file name"))
            if FileManager.default.fileExists(atPath: pkgLockJson.path) {
                try FileManager.default.removeItem(at: pkgLockJson)
            }

            // Init npm directory with .npmrc file
            try await model.createDirectoryStructure(for: packagePath)
            _ = try await model.executeInDirectory(
                in: packagePath.path, [String(localized: "npm-package-manager.npm-init-command", defaultValue: "npm init --yes --scope=codeedit", comment: "Command to initialize npm project")]
            )

            let npmrcPath = packagePath.appending(path: ".npmrc")
            if !FileManager.default.fileExists(atPath: npmrcPath.path) {
                try "install-strategy=shallow".write(to: npmrcPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - NPM Install

    func runNpmInstall(_ source: PackageSource, installDir installationDirectory: URL) -> PackageManagerInstallStep {
        let qualifiedSourceName = String(format: String(localized: "npm-package-manager.qualified-package-name", defaultValue: "%@@%@", comment: "Qualified package name with version"), source.pkgName, source.version)
        let otherPackages = source.options["extraPackages"]?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        var packageList = ([qualifiedSourceName] + otherPackages)

        // FIXME: This will break with localization. Use real Foundation APIs for pluralizing lists.
        let plural = packageList.count > 1
        if plural, var last = packageList.last {
            // Oxford comma
            last = String(localized: "npm-package-manager.list-and-prefix", defaultValue: "and ", comment: "Prefix for last item in list") + last
            packageList[packageList.count - 1] = last
        }
        let packagesDescription = packageList.joined(separator: String(localized: "npm-package-manager.list-separator", defaultValue: ", ", comment: "Separator for package list"))

        let sSuffix = packageList.count > 1 ? String(localized: "npm-package-manager.plural-suffix", defaultValue: "s", comment: "Plural suffix for packages") : ""
        let suffix = plural ? String(localized: "npm-package-manager.these-packages", defaultValue: "these packages", comment: "Plural form for package reference") : String(localized: "npm-package-manager.this-package", defaultValue: "this package", comment: "Singular form for package reference")

        return PackageManagerInstallStep(
            name: String(localized: "npm-package-manager.install-step-name", defaultValue: "Install Package Using npm", comment: "Installation step name for installing package using npm"),
            confirmation: .required(
                message: String(format: String(localized: "npm-package-manager.install-permission-prompt", defaultValue: "This requires the npm package%@ %@.\nAllow CodeEdit to install %@?", comment: "Permission prompt for installing npm package"), sSuffix, packagesDescription, suffix)
            )
        ) { model in
            do {
                var installArgs = ["npm", "install", qualifiedSourceName]
                if let dev = source.options["dev"], dev.lowercased() == "true" {
                    installArgs.append("--save-dev")
                }
                for extraPackage in otherPackages {
                    installArgs.append(extraPackage)
                }

                _ = try await model.executeInDirectory(
                    in: installationDirectory.path(percentEncoded: false),
                    installArgs
                )
            } catch {
                let nodeModulesPath = installationDirectory.appending(path: "node_modules").path(percentEncoded: false)
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
            name: String(localized: "npm-package-manager.verify-step-name", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { _ in
            let packageJsonPath = packagePath.appending(path: String(localized: "npm-package-manager.package-json-file-verify", defaultValue: "package.json", comment: "NPM package.json file name for verification")).path

            // Verify package.json contains the installed package
            guard let packageJsonData = FileManager.default.contents(atPath: packageJsonPath),
                  let packageJson = try? JSONSerialization.jsonObject(with: packageJsonData, options: []),
                  let packageDict = packageJson as? [String: Any],
                  let dependencies = packageDict["dependencies"] as? [String: String],
                  let installedVersion = dependencies[package] else {
                throw PackageManagerError.installationFailed(String(localized: "npm-package-manager.error-package-not-in-json", defaultValue: "Package not found in package.json", comment: "Error message when package not found in package.json"))
            }

            // Verify installed version matches requested version
            let normalizedInstalledVersion = installedVersion.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm-package-manager.version-prefix-chars-installed", defaultValue: "^~", comment: "Version prefix characters to trim from installed version")))
            let normalizedRequestedVersion = version.trimmingCharacters(in: CharacterSet(charactersIn: String(localized: "npm-package-manager.version-prefix-chars-requested", defaultValue: "^~", comment: "Version prefix characters to trim from requested version")))
            if normalizedInstalledVersion != normalizedRequestedVersion &&
                !installedVersion.contains(normalizedRequestedVersion) {
                throw PackageManagerError.installationFailed(
                    String(format: String(localized: "npm-package-manager.error-version-mismatch", defaultValue: "Version mismatch: Expected %@, but found %@", comment: "Error message for version mismatch"), version, installedVersion)
                )
            }

            // Verify the package exists in node_modules
            let packageDirectory = packagePath
                .appending(path: String(localized: "npm-package-manager.node-modules-dir-verify", defaultValue: "node_modules", comment: "Node modules directory name for verification"))
                .appending(path: package)
            guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
                throw PackageManagerError.installationFailed(String(localized: "npm-package-manager.error-package-not-in-modules", defaultValue: "Package not found in node_modules", comment: "Error message when package not found in node_modules"))
            }
        }
    }
}
