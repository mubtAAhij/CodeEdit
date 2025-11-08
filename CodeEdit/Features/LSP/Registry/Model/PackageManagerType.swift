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
            String(localized: "package-manager.golang", defaultValue: "Go", comment: "Go package manager name")
        case .pip:
            String(localized: "package-manager.pip", defaultValue: "Pip", comment: "Pip package manager name")
        case .gem:
            String(localized: "package-manager.gem", defaultValue: "Gem", comment: "Gem package manager name")
        case .nuget:
            String(localized: "package-manager.nuget", defaultValue: "Nuget", comment: "Nuget package manager name")
        case .opam:
            String(localized: "package-manager.opam", defaultValue: "Opam", comment: "Opam package manager name")
        case .composer:
            String(localized: "package-manager.composer", defaultValue: "Composer", comment: "Composer package manager name")
        case .sourceBuild:
            String(localized: "package-manager.source-build", defaultValue: "Build From Source", comment: "Build from source option")
        case .github:
            String(localized: "package-manager.github-download", defaultValue: "Download From GitHub", comment: "Download from GitHub option")
        }
    }
}
