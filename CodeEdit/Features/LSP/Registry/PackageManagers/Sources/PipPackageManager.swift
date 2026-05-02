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
            let pipCommands = [String(localized: "pip.version.command.pip3", defaultValue: "pip3 --version", comment: "Pip3 version command"), String(localized: "pip.version.command.python3", defaultValue: "python3 -m pip --version", comment: "Python3 pip version command")]
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
        let customBinPath = packagePath.appending(path: String(localized: "pip.bin.directory", defaultValue: "bin", comment: "Binary directory name")).appending(path: package).path
        if FileManager.default.fileExists(atPath: customBinPath) {
            return customBinPath
        }
        return packagePath.appending(path: String(localized: "pip.venv.directory", defaultValue: "venv", comment: "Virtual environment directory name")).appending(path: String(localized: "pip.bin.directory.2", defaultValue: "bin", comment: "Binary directory name")).appending(path: package).path
    }

    // MARK: - Initialize

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "pip.initialize.step.name", defaultValue: "Initialize Directory Structure", comment: "Installation step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), [String(localized: "pip.venv.create.command", defaultValue: "python -m venv venv", comment: "Python venv creation command")])

            let requirementsPath = packagePath.appending(path: String(localized: "pip.requirements.txt.filename", defaultValue: "requirements.txt", comment: "Requirements.txt filename"))
            if !FileManager.default.fileExists(atPath: requirementsPath.path) {
                try String(localized: "pip.requirements.txt.header", defaultValue: "# Package requirements\n", comment: "Requirements.txt header comment").write(to: requirementsPath, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - Pip Install

    func runPipInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip.install.step.name", defaultValue: "Install Package Using pip", comment: "Installation step name for installing package using pip"),
            confirmation: .required(
                message: String(format: String(localized: "pip.install.confirmation", defaultValue: "This requires the pip package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message for installing pip package"), source.pkgName)
            )
        ) { model in
            var installArgs = [pipCommand, String(localized: "pip.install.subcommand", defaultValue: "install", comment: "Install subcommand")]

            if source.version.lowercased() != String(localized: "pip.latest.version", defaultValue: "latest", comment: "Latest version keyword") {
                installArgs.append(String(format: String(localized: "pip.package.version.format", defaultValue: "%@==%@", comment: "Package version format"), source.pkgName, source.version))
            } else {
                installArgs.append(source.pkgName)
            }

            let extras = source.options[String(localized: "pip.extra.option", defaultValue: "extra", comment: "Extra option key")]
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
            name: String(localized: "pip.update.requirements.step.name", defaultValue: "Update requirements.txt", comment: "Installation step name for updating requirements.txt"),
            confirmation: .none
        ) { model in
            let requirementsPath = packagePath.appending(path: String(localized: "pip.requirements.txt.filename.2", defaultValue: "requirements.txt", comment: "Requirements.txt filename"))

            let freezeOutput = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip.command.format", defaultValue: "%@", comment: "Pip command format"), pipCommand), String(localized: "pip.freeze.subcommand", defaultValue: "freeze", comment: "Freeze subcommand")]
            )

            await model.status(String(localized: "pip.status.writing.requirements", defaultValue: "Writing requirements to requirements.txt", comment: "Status message for writing requirements"))
            let requirementsContent = freezeOutput.joined(separator: "\n") + "\n"
            try requirementsContent.write(to: requirementsPath, atomically: true, encoding: .utf8)
        }
    }

    // MARK: - Verify Installation

    private func verifyInstallation(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let pipCommand = getPipCommand(in: packagePath)
        return PackageManagerInstallStep(
            name: String(localized: "pip.verify.step.name", defaultValue: "Verify Installation", comment: "Installation step name for verifying installation"),
            confirmation: .none
        ) { model in
            let output = try await model.executeInDirectory(
                in: packagePath.path(percentEncoded: false),
                [String(format: String(localized: "pip.command.format.2", defaultValue: "%@", comment: "Pip command format"), pipCommand), String(localized: "pip.list.subcommand", defaultValue: "list", comment: "List subcommand"), String(localized: "pip.format.freeze.flag", defaultValue: "--format=freeze", comment: "Format freeze flag")]
            )

            // Normalize package names for comparison
            let normalizedPackageHyphen = source.pkgName.replacingOccurrences(of: String(localized: "pip.underscore.char", defaultValue: "_", comment: "Underscore character"), with: String(localized: "pip.hyphen.char", defaultValue: "-", comment: "Hyphen character")).lowercased()
            let normalizedPackageUnderscore = source.pkgName.replacingOccurrences(of: String(localized: "pip.hyphen.char.2", defaultValue: "-", comment: "Hyphen character"), with: String(localized: "pip.underscore.char.2", defaultValue: "_", comment: "Underscore character")).lowercased()

            // Check if the package name appears in requirements.txt
            let installedPackages = output.map { line in
                line.lowercased().split(separator: Character(String(localized: "pip.equals.separator", defaultValue: "=", comment: "Equals separator"))).first?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let packageFound = installedPackages.contains { installedPackage in
                installedPackage == normalizedPackageHyphen || installedPackage == normalizedPackageUnderscore
            }

            guard packageFound else {
                throw PackageManagerError.installationFailed(String(format: String(localized: "pip.error.package.not.found.in.list", defaultValue: "Package %@ not found in pip list", comment: "Error message when package is not found in pip list"), source.pkgName))
            }
        }
    }

    private func getPipCommand(in packagePath: URL) -> String {
        let venvPip = String(localized: "pip.venv.pip.path", defaultValue: "venv/bin/pip", comment: "Virtual environment pip path")
        return FileManager.default.fileExists(atPath: packagePath.appending(path: venvPip).path)
        ? venvPip
        : String(localized: "pip.python3.pip.command", defaultValue: "python3 -m pip", comment: "Python3 pip command")
    }
}
