//
//  PipPackageManager.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/3/25.
//

import Foundation

final class PipPackageManager: PackageManagerProtocol {
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
            runPipInstall(source, in: packagePath),
            updateRequirements(in: packagePath),
            verifyInstallation(source, in: packagePath)
        ]
    }

    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: "", confirmation: .none) { model in
            let pipCommands = ["pip3 --version", "python3 -m pip --version"]
            var didFindPip = false
            for command in pipCommands {
                do {
                    let versionOutput = try await model.runCommand(command)
                    let versionPattern = #"pip \d+\.\d+"#
                    let output = versionOutput.reduce(into: "") {
                        $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if output.range(of: versionPattern, options: .regularExpression) != nil {
                        didFindPip = true
                        break
                    }
                } catch {
                    continue
                }
            }
            guard didFindPip else {
                throw PackageManagerError.packageManagerNotInstalled
            }
        }

    }

    /// Get the binary path for a Python package
    func getBinaryPath(for package: String) -> String {
        let packagePath = installationDirectory.appending(path: package)
        let customBinPath = packagePath.appending(path: "bin").appending(path: package).path
        if FileManager.default.fileExists(atPath: customBinPath) {
            return customBinPath
        }
        return packagePath.appending(path: "venv").appending(path: "bin").appending(path: package).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "pip-package-manager.initialize-step-name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), [String(localized: "pip-package-manager.venv-create-command", defaultValue: "python -m venv venv", comment: "Command to create Python virtual environment")])

            let requirementsPath = packagePath.appending(path: "requirements.txt")
            if !FileManager.default.fileExists(atPath: requirementsPath.path) {
                try String(localized: "pip-package-manager.requirements-header", defaultValue: "# Package requirements\n", comment: "Header comment for requirements file").write(to: requirementsPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - Pip Install

    func runPipInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip-package-manager.install-step-name", defaultValue: "Install Package Using pip", comment: "Installation step name for installing package using pip"),
            confirmation: .required(
                message: String(format: String(localized: "pip-package-manager.install-permission-prompt", defaultValue: "This requires the pip package %@.\nAllow CodeEdit to install this package?", comment: "Permission prompt for installing pip package"), source.pkgName)
            )
        ) { model in
            var installArgs = [pipCommand, String(localized: "pip-package-manager.install-command", defaultValue: "install", comment: "Install subcommand for pip")]

            if source.version.lowercased() != String(localized: "pip-package-manager.version-latest", defaultValue: "latest", comment: "Latest version keyword") {
                installArgs.append(String(format: String(localized: "pip-package-manager.package-with-version", defaultValue: "%@==%@", comment: "Package with specific version format"), source.pkgName, source.version))
            } else {
                installArgs.append(source.pkgName)
            }

            let extras = source.options["extra"]
            if let extras {
                if let lastIndex = installArgs.indices.last {
                    installArgs[lastIndex] += String(format: String(localized: "pip-package-manager.package-extras-format", defaultValue: "[%@]", comment: "Format for package extras"), extras)
                }
            }

            try await model.executeInDirectory(in: packagePath.path, installArgs)
        }
    }

    // MARK: - Update Requirements.txt

    /// Update the requirements.txt file with the installed package and extras
    private func updateRequirements(in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip-package-manager.update-requirements-step-name", defaultValue: "Update requirements.txt", comment: "Installation step name for updating requirements file"),
            confirmation: .none
        ) { model in
            let requirementsPath = packagePath.appending(path: "requirements.txt")

            let freezeOutput = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip-package-manager.pip-command-format", defaultValue: "%@", comment: "Pip command format"), pipCommand), String(localized: "pip-package-manager.freeze-command", defaultValue: "freeze", comment: "Freeze subcommand for pip")]
            )

            await model.status("Writing requirements to requirements.txt")
            let requirementsContent = freezeOutput.joined(separator: "\n") + "\n"
            try requirementsContent.write(to: requirementsPath, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - Verify Installation

    private func verifyInstallation(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip-package-manager.verify-step-name", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { model in
            let output = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip-package-manager.pip-command-verify", defaultValue: "%@", comment: "Pip command for verification"), pipCommand), String(localized: "pip-package-manager.list-command", defaultValue: "list", comment: "List subcommand for pip"), String(localized: "pip-package-manager.format-freeze-flag", defaultValue: "--format=freeze", comment: "Format flag for pip list")]
            )

            // Normalize package names for comparison
            let normalizedPackageHyphen = source.pkgName.replacingOccurrences(of: String(localized: "pip-package-manager.underscore-char", defaultValue: "_", comment: "Underscore character for replacement"), with: String(localized: "pip-package-manager.hyphen-char", defaultValue: "-", comment: "Hyphen character for replacement")).lowercased()
            let normalizedPackageUnderscore = source.pkgName.replacingOccurrences(of: String(localized: "pip-package-manager.hyphen-char-2", defaultValue: "-", comment: "Hyphen character for replacement"), with: String(localized: "pip-package-manager.underscore-char-2", defaultValue: "_", comment: "Underscore character for replacement")).lowercased()

            // Check if the package name appears in requirements.txt
            let installedPackages = output.map { line in
                line.lowercased().split(separator: "=").first?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let packageFound = installedPackages.contains { installedPackage in
                installedPackage == normalizedPackageHyphen || installedPackage == normalizedPackageUnderscore
            }

            guard packageFound else {
                throw PackageManagerError.installationFailed(String(format: String(localized: "pip-package-manager.error-package-not-found", defaultValue: "Package %@ not found in pip list", comment: "Error message when package not found in pip list"), source.pkgName))
            }
        }
    }

    private func getPipCommand(in packagePath: URL) -> String {
        let venvPip = "venv/bin/pip"
        return FileManager.default.fileExists(atPath: packagePath.appending(path: venvPip).path)
        ? venvPip
        : "python3 -m pip"
    }
}
