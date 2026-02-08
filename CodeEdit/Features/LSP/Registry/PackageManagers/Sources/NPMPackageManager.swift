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
                message: String(localized: "npm.install-permission", defaultValue: "This package requires npm to install. Allow CodeEdit to run npm commands?", comment: "NPM install permission message")
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
            .appending(path: "node_modules")
            .appending(path: ".bin")
        return binDirectory.appending(path: package).path
    }

    // MARK: - Initialize

    /// Initializes the npm project if not already initialized
    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "npm.install-step.initialize-directory", defaultValue: "Initialize Directory Structure", comment: "Initialize directory structure step"), confirmation: .none) { model in
            // Clean existing files
            let pkgJson = packagePath.appending(path: "package.json")
            if FileManager.default.fileExists(atPath: pkgJson.path) {
                try FileManager.default.removeItem(at: pkgJson)
            }
            let pkgLockJson = packagePath.appending(path: "package-lock.json")
            if FileManager.default.fileExists(atPath: pkgLockJson.path) {
                try FileManager.default.removeItem(at: pkgLockJson)
            }

            // Init npm directory with .npmrc file
            try await model.createDirectoryStructure(for: packagePath)
            _ = try await model.executeInDirectory(
                in: packagePath.path, ["npm init --yes --scope=codeedit"]
            )

            let npmrcPath = packagePath.appending(path: ".npmrc")
            if !FileManager.default.fileExists(atPath: npmrcPath.path) {
                try "install-strategy=shallow".write(to: npmrcPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - NPM Install

    func runNpmInstall(_ source: PackageSource, installDir installationDirectory: URL) -> PackageManagerInstallStep {
        let qualifiedSourceName = "\(source.pkgName)@\(source.version)"
        let otherPackages = source.options["extraPackages"]?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

        var packageList = ([qualifiedSourceName] + otherPackages)

        // FIXME: This will break with localization. Use real Foundation APIs for pluralizing lists.
        let plural = packageList.count > 1
        if plural, var last = packageList.last {
            // Oxford comma
            last = "and " + last
            packageList[packageList.count - 1] = last
        }
        let packagesDescription = packageList.joined(separator: ", ")

        let sSuffix = packageList.count > 1 ? "s" : ""
        let suffix = plural ? String(localized: "npm.these-packages", defaultValue: "these packages", comment: "These packages plural") : String(localized: "npm.this-package", defaultValue: "this package", comment: "This package singular")

        return PackageManagerInstallStep(
            name: String(localized: "npm.install-step.install-package", defaultValue: "Install Package Using npm", comment: "Install package using npm step"),
            confirmation: .required(
                message: String(format: NSLocalizedString("npm.install-confirmation", comment: "NPM install confirmation message"), sSuffix, packagesDescription, suffix)
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
            name: String(localized: "npm.install-step.verify-installation", defaultValue: "Verify Installation", comment: "Verify installation step"),
            confirmation: .none
        ) { _ in
            let packageJsonPath = packagePath.appending(path: "package.json").path

            // Verify package.json contains the installed package
            guard let packageJsonData = FileManager.default.contents(atPath: packageJsonPath),
                  let packageJson = try? JSONSerialization.jsonObject(with: packageJsonData, options: []),
                  let packageDict = packageJson as? [String: Any],
                  let dependencies = packageDict["dependencies"] as? [String: String],
                  let installedVersion = dependencies[package] else {
                throw PackageManagerError.installationFailed(String(localized: "npm.error.package-not-in-json", defaultValue: "Package not found in package.json", comment: "Package not found in package.json error"))
            }

            // Verify installed version matches requested version
            let normalizedInstalledVersion = installedVersion.trimmingCharacters(in: CharacterSet(charactersIn: "^~"))
            let normalizedRequestedVersion = version.trimmingCharacters(in: CharacterSet(charactersIn: "^~"))
            if normalizedInstalledVersion != normalizedRequestedVersion &&
                !installedVersion.contains(normalizedRequestedVersion) {
                throw PackageManagerError.installationFailed(
                    String(format: NSLocalizedString("npm.error.version-mismatch", comment: "Version mismatch error"), version, installedVersion)
                )
            }

            // Verify the package exists in node_modules
            let packageDirectory = packagePath
                .appending(path: "node_modules")
                .appending(path: package)
            guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
                throw PackageManagerError.installationFailed(String(localized: "npm.error.package-not-in-node-modules", defaultValue: "Package not found in node_modules", comment: "Package not found in node_modules error"))
            }
        }
    }
}
