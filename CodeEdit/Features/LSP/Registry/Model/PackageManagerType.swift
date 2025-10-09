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
            String(localized: "package_manager.go", comment: "Display name for Go package manager")
        case .pip:
            String(localized: "package_manager.pip", comment: "Display name for Pip package manager")
        case .gem:
            String(localized: "package_manager.gem", comment: "Display name for Gem package manager")
        case .nuget:
            String(localized: "package_manager.nuget", comment: "Display name for NuGet package manager")
        case .opam:
            String(localized: "package_manager.opam", comment: "Display name for OPAM package manager")
        case .composer:
            String(localized: "package_manager.composer", comment: "Display name for Composer package manager")
        case .sourceBuild:
            String(localized: "package_manager.build_from_source", comment: "Display name for building packages from source")
        case .github:
            String(localized: "package_manager.download_from_github", comment: "Display name for downloading from GitHub")
        }
    }
}
