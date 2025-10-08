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
            "NPM"
        case .cargo:
            "Cargo"
        case .golang:
            String(localized: "package_manager.go", comment: "Go package manager type")
        case .pip:
            String(localized: "package_manager.pip", comment: "Pip package manager type")
        case .gem:
            String(localized: "package_manager.gem", comment: "Gem package manager type")
        case .nuget:
            String(localized: "package_manager.nuget", comment: "NuGet package manager type")
        case .opam:
            String(localized: "package_manager.opam", comment: "OPAM package manager type")
        case .composer:
            String(localized: "package_manager.composer", comment: "Composer package manager type")
        case .sourceBuild:
            String(localized: "package_manager.build_from_source", comment: "Build from source installation method")
        case .github:
            String(localized: "package_manager.download_from_github", comment: "Download from GitHub installation method")
        }
    }
}
