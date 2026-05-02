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
            let versionOutput = try await model.runCommand(String(localized: "cargo.package.manager.version.command", defaultValue: "cargo --version", comment: "Command to check cargo version"))
            let output = versionOutput.reduce(into: "") {
                $0 += $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            guard output.starts(with: String(localized: "cargo.package.manager.name", defaultValue: "cargo", comment: "Cargo package manager name")) else {
                throw PackageManagerError.packageManagerNotInstalled
            }
        }
    }

    func getBinaryPath(for package: String) -> String {
        return installationDirectory.appending(path: package).appending(path: String(localized: "cargo.package.manager.bin.path", defaultValue: "bin", comment: "Binary directory path for cargo packages")).path
    }

    func initialize(in packagePath: URL) -> PackageManagerInstallStep {
        PackageManagerInstallStep(name: String(localized: "cargo.package.manager.initialize.step", defaultValue: "Initialize Directory Structure", comment: "Step name for initializing directory structure"), confirmation: .none) { model in
            try await model.createDirectoryStructure(for: packagePath)
        }
    }

    func runCargoInstall(_ source: PackageSource, in packagePath: URL) -> PackageManagerInstallStep {
        let qualifiedPackageName = String(format: String(localized: "cargo.package.manager.qualified.name.format", defaultValue: "%@%@%@", comment: "Format for qualified package name with name and version"), source.pkgName, String(localized: "cargo.package.manager.version.separator", defaultValue: "@", comment: "Separator between package name and version"), source.version)

        return PackageManagerInstallStep(
            name: String(localized: "cargo.package.manager.install.step", defaultValue: "Install Package Using cargo", comment: "Step name for installing package using cargo"),
            confirmation: .required(
                message: String(format: String(localized: "cargo.package.manager.install.confirmation.format", defaultValue: "This requires the cargo package %@.\nAllow CodeEdit to install this package?", comment: "Confirmation message for cargo package installation"), qualifiedPackageName)
            )
        ) { model in
            var cargoArgs = [String(localized: "cargo.package.manager.command", defaultValue: "cargo", comment: "Cargo command"), String(localized: "cargo.package.manager.install.subcommand", defaultValue: "install", comment: "Install subcommand for cargo"), String(localized: "cargo.package.manager.root.flag", defaultValue: "--root", comment: "Root flag for cargo install"), String(localized: "cargo.package.manager.root.value", defaultValue: ".", comment: "Current directory value for cargo root")]

            // If this is a git-based package
            if let gitRef = source.gitReference, let repoUrl = source.repositoryUrl {
                cargoArgs.append(contentsOf: [String(localized: "cargo.package.manager.git.flag", defaultValue: "--git", comment: "Git flag for cargo install"), repoUrl])
                switch gitRef {
                case .tag(let tag):
                    cargoArgs.append(contentsOf: [String(localized: "cargo.package.manager.tag.flag", defaultValue: "--tag", comment: "Tag flag for cargo install"), tag])
                case .revision(let rev):
                    cargoArgs.append(contentsOf: [String(localized: "cargo.package.manager.rev.flag", defaultValue: "--rev", comment: "Revision flag for cargo install"), rev])
                }
            } else {
                cargoArgs.append(qualifiedPackageName)
            }

            if let features = source.options[String(localized: "cargo.package.manager.features.option", defaultValue: "features", comment: "Features option key for cargo")] {
                cargoArgs.append(contentsOf: [String(localized: "cargo.package.manager.features.flag", defaultValue: "--features", comment: "Features flag for cargo install"), features])
            }
            if source.options[String(localized: "cargo.package.manager.locked.option", defaultValue: "locked", comment: "Locked option key for cargo")] == String(localized: "cargo.package.manager.locked.value", defaultValue: "true", comment: "True value for locked option") {
                cargoArgs.append(String(localized: "cargo.package.manager.locked.flag", defaultValue: "--locked", comment: "Locked flag for cargo install"))
            }

            try await model.executeInDirectory(in: packagePath.path(percentEncoded: false), cargoArgs)
        }
    }
}
