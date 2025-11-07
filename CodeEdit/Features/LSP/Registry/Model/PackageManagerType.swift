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
            String(
                localized: "package-manager.npm",
                defaultValue: "NPM",
                comment: "Package manager name for NPM"
            )
        case .cargo:
            String(
                localized: "package-manager.cargo",
                defaultValue: "Cargo",
                comment: "Package manager name for Cargo"
            )
        case .golang:
            String(
                localized: "package-manager.go",
                defaultValue: "Go",
                comment: "Package manager name for Go"
            )
        case .pip:
            String(
                localized: "package-manager.pip",
                defaultValue: "Pip",
                comment: "Package manager name for Pip"
            )
        case .gem:
            String(
                localized: "package-manager.gem",
                defaultValue: "Gem",
                comment: "Package manager name for Gem"
            )
        case .nuget:
            String(
                localized: "package-manager.nuget",
                defaultValue: "Nuget",
                comment: "Package manager name for Nuget"
            )
        case .opam:
            String(
                localized: "package-manager.opam",
                defaultValue: "Opam",
                comment: "Package manager name for Opam"
            )
        case .composer:
            String(
                localized: "package-manager.composer",
                defaultValue: "Composer",
                comment: "Package manager name for Composer"
            )
        case .sourceBuild:
            String(
                localized: "package-manager.build-from-source",
                defaultValue: "Build From Source",
                comment: "Package manager option for building from source"
            )
        case .github:
            String(
                localized: "package-manager.download-from-github",
                defaultValue: "Download From GitHub",
                comment: "Package manager option for downloading from GitHub"
            )
        }
    }
}
