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
            let pipCommands = [String(localized: "pip.package-manager.pip3-version-command", defaultValue: "pip3 --version", comment: "Command to check pip3 version"), String(localized: "pip.package-manager.python3-pip-version-command", defaultValue: "python3 -m pip --version", comment: "Command to check python3 pip version")]
            var didFindPip = false
            for command in pipCommands {
                do {
                    let versionOutput = try await model.runCommand(command)
                    let versionPattern = String(localized: "pip.package-manager.version-pattern", defaultValue: #"pip \d+\.\d+"#, comment: "Regular expression pattern to match pip version")
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
        let customBinPath = packagePath.appending(path: String(localized: "pip.package-manager.bin-directory", defaultValue: "bin", comment: "Binary directory name")).appending(path: package).path
        if FileManager.default.fileExists(atPath: customBinPath) {
            return customBinPath
        }
        return packagePath.appending(path: String(localized: "pip.package-manager.venv-directory", defaultValue: "venv", comment: "Virtual environment directory name")).appending(path: String(localized: "pip.package-manager.bin-directory", defaultValue: "bin", comment: "Binary directory name")).appending(path: package).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "pip.package-manager.initialize-step", defaultValue: "Initialize Directory Structure", comment: "Step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), [String(localized: "pip.package-manager.venv-create-command", defaultValue: "python -m venv venv", comment: "Command to create virtual environment")])

            let requirementsPath = packagePath.appending(path: String(localized: "pip.package-manager.requirements-file", defaultValue: "requirements.txt", comment: "Requirements file name"))
            if !FileManager.default.fileExists(atPath: requirementsPath.path) {
                try String(localized: "pip.package-manager.requirements-header", defaultValue: "# Package requirements\n", comment: "Header comment for requirements file").write(to: requirementsPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - Pip Install

    func runPipInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip.package-manager.install-step", defaultValue: "Install Package Using pip", comment: "Step name for installing package using pip"),
            confirmation: .required(
                message: String(format: String(localized: "pip.package-manager.install-confirmation", defaultValue: "This requires the pip package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message for installing pip package"), source.pkgName)
            )
        ) { model in
            var installArgs = [pipCommand, String(localized: "pip.package-manager.install-command", defaultValue: "install", comment: "Install subcommand")]

            if source.version.lowercased() != String(localized: "pip.package-manager.latest-version", defaultValue: "latest", comment: "Latest version keyword") {
                installArgs.append(String(format: String(localized: "pip.package-manager.package-version-format", defaultValue: "%@==%@", comment: "Package version format"), source.pkgName, source.version))
            } else {
                installArgs.append(source.pkgName)
            }

            let extras = source.options["extra"]
            if let extras {
                if let lastIndex = installArgs.indices.last {
                    installArgs[lastIndex] += String(format: String(localized: "pip.package-manager.extras-format", defaultValue: "[%@]", comment: "Extras format for package"), extras)
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
            name: String(localized: "pip.package-manager.update-requirements-step", defaultValue: "Update requirements.txt", comment: "Step name for updating requirements.txt"),
            confirmation: .none
        ) { model in
            let requirementsPath = packagePath.appending(path: String(localized: "pip.package-manager.requirements-file", defaultValue: "requirements.txt", comment: "Requirements file name"))

            let freezeOutput = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [pipCommand, String(localized: "pip.package-manager.freeze-command", defaultValue: "freeze", comment: "Freeze subcommand for pip")]
            )

            await model.status(String(localized: "pip.package-manager.writing-requirements-status", defaultValue: "Writing requirements to requirements.txt", comment: "Status message while writing requirements"))
            let requirementsContent = freezeOutput.joined(separator: "\n") + "\n"
            try requirementsContent.write(to: requirementsPath, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - Verify Installation

    private func verifyInstallation(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip.package-manager.verify-step", defaultValue: "Verify Installation", comment: "Step name for verifying installation"),
            confirmation: .none
        ) { model in
            let output = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [pipCommand, String(localized: "pip.package-manager.list-command", defaultValue: "list", comment: "List subcommand for pip"), String(localized: "pip.package-manager.format-freeze-flag", defaultValue: "--format=freeze", comment: "Format freeze flag for pip list")]
            )

            // Normalize package names for comparison
            let normalizedPackageHyphen = source.pkgName.replacingOccurrences(of: "_", with: "-").lowercased()
            let normalizedPackageUnderscore = source.pkgName.replacingOccurrences(of: "-", with: "_").lowercased()

            // Check if the package name appears in requirements.txt
            let installedPackages = output.map { line in
                line.lowercased().split(separator: "=").first?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let packageFound = installedPackages.contains { installedPackage in
                installedPackage == normalizedPackageHyphen || installedPackage == normalizedPackageUnderscore
            }

            guard packageFound else {
                throw PackageManagerError.installationFailed(String(format: String(localized: "pip.package-manager.package-not-found-error", defaultValue: "Package %@ not found in pip list", comment: "Error message when package is not found in pip list"), source.pkgName))
            }
        }
    }

    private func getPipCommand(in packagePath: URL) -> String {
        let venvPip = String(localized: "pip.package-manager.venv-pip-path", defaultValue: "venv/bin/pip", comment: "Path to pip in virtual environment")
        return FileManager.default.fileExists(atPath: packagePath.appending(path: venvPip).path)
        ? venvPip
        : String(localized: "pip.package-manager.python3-pip-command", defaultValue: "python3 -m pip", comment: "Command to run pip using python3")
    }
}
