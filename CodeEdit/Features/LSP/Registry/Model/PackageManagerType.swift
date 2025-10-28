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
            String(localized: "package_manager.npm", comment: "NPM package manager")
        case .cargo:
            String(localized: "package_manager.cargo", comment: "Cargo package manager")
        case .golang:
            String(localized: "package_manager.go", comment: "Go package manager")
        case .pip:
            String(localized: "package_manager.pip", comment: "Pip package manager")
        case .gem:
            String(localized: "package_manager.gem", comment: "Gem package manager")
        case .nuget:
            String(localized: "package_manager.nuget", comment: "Nuget package manager")
        case .opam:
            String(localized: "package_manager.opam", comment: "Opam package manager")
        case .composer:
            String(localized: "package_manager.composer", comment: "Composer package manager")
        case .sourceBuild:
            String(localized: "package_manager.build_from_source", comment: "Build from source")
        case .github:
            String(localized: "package_manager.download_from_github", comment: "Download from GitHub")
        }
    }
}
