//
//  PackageManagerType.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/12/25.
//

/// Package manager types supported by the system
enum PackageManagerType: String, Codable {
    /// JavaScript
    case npm
    /// Rust
    case cargo
    /// Go
    case golang
    /// Python
    case pip
    /// Ruby
    case gem
    /// C#
    case nuget
    /// OCaml
    case opam
    /// PHP
    case composer
    /// Building from source
    case sourceBuild
    /// Binary download
    case github

    var userDescription: String {
        switch self {
        case .npm:
            String(localized: "package_manager.npm", defaultValue: "NPM", comment: "NPM package manager")
        case .cargo:
            String(localized: "package_manager.cargo", defaultValue: "Cargo", comment: "Cargo package manager")
        case .golang:
            String(localized: "package_manager.go", defaultValue: "Go", comment: "Go package manager")
        case .pip:
            String(localized: "package_manager.pip", defaultValue: "Pip", comment: "Pip package manager")
        case .gem:
            String(localized: "package_manager.gem", defaultValue: "Gem", comment: "Gem package manager")
        case .nuget:
            String(localized: "package_manager.nuget", defaultValue: "Nuget", comment: "Nuget package manager")
        case .opam:
            String(localized: "package_manager.opam", defaultValue: "Opam", comment: "Opam package manager")
        case .composer:
            String(localized: "package_manager.composer", defaultValue: "Composer", comment: "Composer package manager")
        case .sourceBuild:
            String(localized: "package_manager.build_from_source", defaultValue: "Build From Source", comment: "Build from source option")
        case .github:
            String(localized: "package_manager.download_from_github", defaultValue: "Download From GitHub", comment: "Download from GitHub option")
        }
    }
}
