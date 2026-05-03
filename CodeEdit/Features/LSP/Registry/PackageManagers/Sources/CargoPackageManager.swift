//
//  CargoPackageManager.swift
//  CodeEdit
//
//  Created by Abe Malla on 2/3/25.
//

import Foundation

final class CargoPackageManager: PackageManagerProtocol {
    private let installationDirectory: URL

    let shellClient: ShellClient

    init(installationDirectory: URL) {
        self.installationDirectory = installationDirectory
        self.shellClient = .live()
    }

    func install(method installationMethod: InstallationMethod) throws -> [PackageManagerInstallStep] {
        guard case .standardPackage(let source) = installationMethod else {
            throw PackageManagerError.invalidConfiguration
        }
        let packagePath = installationDirectory.appending(path: source.entryName)
        return [
            initialize(in: packagePath),
            runCargoInstall(source, in: packagePath)
        ]
    }

    func isInstalled(method installationMethod: InstallationMethod) -> PackageManagerInstallStep {
        PackageManagerInstallStep(
            name: "",
            confirmation: .none
        ) { model in
            let versionOutput = try await model.runCommand(String(localized: "cargo.version_command", defaultValue: "cargo --version", comment: "Cargo version command"))
            let output = versionOutput.reduce(into: "") {
                $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            guard output.starts(with: String(localized: "cargo.name", defaultValue: "cargo", comment: "Cargo package manager name")) else {
                throw PackageManagerError.packageManagerNotInstalled
            }
        }
    }

    func getBinaryPath(for package: String) -> String {
        return installationDirectory.appending(path: package).appending(path: String(localized: "cargo.bin_directory", defaultValue: "bin", comment: "Binary directory name")).path
    }

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "cargo.initialize_directory.step_name", defaultValue: "Initialize Directory Structure", comment: "Step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
        }
    }

    func runCargoInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let qualifiedPackageName = String(format: String(localized: "cargo.qualified_package_name_format", defaultValue: "%@%@%@", comment: "Format for qualified package name (package name, @, version)"), source.pkgName, "@", source.version)

        return PackageManagerInstallStep(
            name: String(localized: "cargo.install_package.step_name", defaultValue: "Install Package Using cargo", comment: "Step name for installing package using cargo"),
            confirmation: .required(
                message: String(format: String(localized: "cargo.install_package.confirmation_message", defaultValue: "This requires the cargo package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message for installing cargo package (qualified package name)"), qualifiedPackageName)
            )
        ) { model in
            var cargoArgs = [String(localized: "cargo.command.cargo", defaultValue: "cargo", comment: "Cargo command name"), String(localized: "cargo.command.install", defaultValue: "install", comment: "Cargo install subcommand"), String(localized: "cargo.command.root_flag", defaultValue: "--root", comment: "Cargo root flag"), String(localized: "cargo.command.current_directory", defaultValue: ".", comment: "Current directory path")]

            // If this is a git-based package
            if let gitRef = source.gitReference, let repoUrl = source.repositoryUrl {
                cargoArgs.append(contentsOf: [String(localized: "cargo.command.git_flag", defaultValue: "--git", comment: "Cargo git flag"), repoUrl])
                switch gitRef {
                case .tag(let tag):
                    cargoArgs.append(contentsOf: [String(localized: "cargo.command.tag_flag", defaultValue: "--tag", comment: "Cargo tag flag"), tag])
                case .revision(let rev):
                    cargoArgs.append(contentsOf: [String(localized: "cargo.command.rev_flag", defaultValue: "--rev", comment: "Cargo revision flag"), rev])
                }
            } else {
                cargoArgs.append(qualifiedPackageName)
            }

            if let features = source.options[String(localized: "cargo.option.features_key", defaultValue: "features", comment: "Features option key")] {
                cargoArgs.append(contentsOf: [String(localized: "cargo.command.features_flag", defaultValue: "--features", comment: "Cargo features flag"), features])
            }
            if source.options[String(localized: "cargo.option.locked_key", defaultValue: "locked", comment: "Locked option key")] == String(localized: "cargo.option.locked_value", defaultValue: "true", comment: "Locked option value") {
                cargoArgs.append(String(localized: "cargo.command.locked_flag", defaultValue: "--locked", comment: "Cargo locked flag"))
            }

            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), cargoArgs)
        }
    }
}
