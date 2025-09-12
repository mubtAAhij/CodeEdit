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
            String(localized: "npm_package_manager", comment: "Display name for NPM package manager")
        case .cargo:
            String(localized: "package_manager_cargo", comment: "Cargo package manager name")
        case .golang:
            String(localized: "package_manager_go", comment: "Go package manager name")
        case .pip:
            String(localized: "package_manager_pip", comment: "Pip package manager name")
        case .gem:
            String(localized: "package_manager_gem", comment: "Gem package manager name")
        case .nuget:
            String(localized: "package_manager_nuget", comment: "Nuget package manager name")
        case .opam:
            String(localized: "package_manager_opam", comment: "Opam package manager name")
        case .composer:
            String(localized: "package_manager_composer", comment: "Composer package manager name")
        case .sourceBuild:
            String(localized: "package_manager_build_from_source", comment: "Build from source installation method")
        case .github:
            String(localized: "package_manager_download_from_github", comment: "Download from GitHub installation method")
        }
    }
}
