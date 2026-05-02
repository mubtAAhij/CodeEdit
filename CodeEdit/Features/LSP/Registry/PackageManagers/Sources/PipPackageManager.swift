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
            let pipCommands = [String(localized: "pip-pm.command.pip3-version", defaultValue: "pip3 --version", comment: "Command to check pip3 version"), String(localized: "pip-pm.command.python3-pip-version", defaultValue: "python3 -m pip --version", comment: "Command to check python3 pip version")]
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
        let customBinPath = packagePath.appending(path: String(localized: "pip-pm.dir.bin", defaultValue: "bin", comment: "Binary directory name")).appending(path: package).path
        if FileManager.default.fileExists(atPath: customBinPath) {
            return customBinPath
        }
        return packagePath.appending(path: String(localized: "pip-pm.dir.venv", defaultValue: "venv", comment: "Virtual environment directory name")).appending(path: String(localized: "pip-pm.dir.bin-venv", defaultValue: "bin", comment: "Binary directory name in venv")).appending(path: package).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "pip-pm.step.initialize", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), [String(localized: "pip-pm.command.create-venv", defaultValue: "python -m venv venv", comment: "Command to create virtual environment")])

            let requirementsPath = packagePath.appending(path: String(localized: "pip-pm.file.requirements", defaultValue: "requirements.txt", comment: "Requirements file name"))
            if !FileManager.default.fileExists(atPath: requirementsPath.path) {
                try String(localized: "pip-pm.content.requirements-header", defaultValue: "# Package requirements\n", comment: "Header content for requirements file").write(to: requirementsPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - Pip Install

    func runPipInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip-pm.step.install", defaultValue: "Install Package Using pip", comment: "Installation step name for installing package with pip"),
            confirmation: .required(
                message: String(format: String(localized: "pip-pm.confirmation.install-package", defaultValue: "This requires the pip package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message to install pip package"), source.pkgName)
            )
        ) { model in
            var installArgs = [pipCommand, String(localized: "pip-pm.command.install", defaultValue: "install", comment: "install subcommand")]

            if source.version.lowercased() != String(localized: "pip-pm.version.latest", defaultValue: "latest", comment: "Latest version keyword") {
                installArgs.append(String(format: String(localized: "pip-pm.format.package-version", defaultValue: "%@==%@", comment: "Package name with version"), source.pkgName, source.version))
            } else {
                installArgs.append(source.pkgName)
            }

            let extras = source.options[String(localized: "pip-pm.option.extra", defaultValue: "extra", comment: "Extra option key")]
            if let extras {
                if let lastIndex = installArgs.indices.last {
                    installArgs[lastIndex] += "[\(extras)]"
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
            name: String(localized: "pip-pm.step.update-requirements", defaultValue: "Update requirements.txt", comment: "Installation step name for updating requirements file"),
            confirmation: .none
        ) { model in
            let requirementsPath = packagePath.appending(path: String(localized: "pip-pm.file.requirements-update", defaultValue: "requirements.txt", comment: "Requirements file name for update"))

            let freezeOutput = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip-pm.format.pip-command", defaultValue: "%@", comment: "Pip command placeholder"), pipCommand), String(localized: "pip-pm.command.freeze", defaultValue: "freeze", comment: "freeze subcommand")]
            )

            await model.status(String(localized: "pip-pm.status.writing-requirements", defaultValue: "Writing requirements to requirements.txt", comment: "Status message when writing requirements file"))
            let requirementsContent = freezeOutput.joined(separator: "\n") + "\n"
            try requirementsContent.write(to: requirementsPath, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - Verify Installation

    private func verifyInstallation(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip-pm.step.verify", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { model in
            let output = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip-pm.format.pip-command-verify", defaultValue: "%@", comment: "Pip command placeholder for verify"), pipCommand), String(localized: "pip-pm.command.list", defaultValue: "list", comment: "list subcommand"), String(localized: "pip-pm.arg.format-freeze", defaultValue: "--format=freeze", comment: "Format freeze argument")]
            )

            // Normalize package names for comparison
            let normalizedPackageHyphen = source.pkgName.replacingOccurrences(of: String(localized: "pip-pm.char.underscore", defaultValue: "_", comment: "Underscore character"), with: String(localized: "pip-pm.char.hyphen", defaultValue: "-", comment: "Hyphen character")).lowercased()
            let normalizedPackageUnderscore = source.pkgName.replacingOccurrences(of: String(localized: "pip-pm.char.hyphen-replace", defaultValue: "-", comment: "Hyphen character for replacement"), with: String(localized: "pip-pm.char.underscore-replace", defaultValue: "_", comment: "Underscore character for replacement")).lowercased()

            // Check if the package name appears in requirements.txt
            let installedPackages = output.map { line in
                line.lowercased().split(separator: Character(String(localized: "pip-pm.separator.equals", defaultValue: "=", comment: "Equals separator"))).first?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let packageFound = installedPackages.contains { installedPackage in
                installedPackage == normalizedPackageHyphen || installedPackage == normalizedPackageUnderscore
            }

            guard packageFound else {
                throw PackageManagerError.installationFailed(String(format: String(localized: "pip-pm.error.package-not-found-list", defaultValue: "Package %@ not found in pip list", comment: "Error when package not found in pip list"), source.pkgName))
            }
        }
    }

    private func getPipCommand(in packagePath: URL) -> String {
        let venvPip = String(localized: "pip-pm.path.venv-pip", defaultValue: "venv/bin/pip", comment: "Path to pip in virtual environment")
        return FileManager.default.fileExists(atPath: packagePath.appending(path: venvPip).path)
        ? venvPip
        : String(localized: "pip-pm.command.python3-pip", defaultValue: "python3 -m pip", comment: "Python3 pip command")
    }
}
