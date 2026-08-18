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
                localized: "lsp.registry.package-manager-type.npm",
                defaultValue: "NPM",
                comment: "Display name for NPM package manager"
            )
        case .cargo:
            String(
                localized: "lsp.registry.package-manager-type.cargo",
                defaultValue: "Cargo",
                comment: "Display name for Cargo package manager"
            )
        case .golang:
            String(
                localized: "lsp.registry.package-manager-type.go",
                defaultValue: "Go",
                comment: "Display name for Go package manager"
            )
        case .pip:
            String(
                localized: "lsp.registry.package-manager-type.pip",
                defaultValue: "Pip",
                comment: "Display name for Pip package manager"
            )
        case .gem:
            String(
                localized: "lsp.registry.package-manager-type.gem",
                defaultValue: "Gem",
                comment: "Display name for Gem package manager"
            )
        case .nuget:
            String(
                localized: "lsp.registry.package-manager-type.nuget",
                defaultValue: "Nuget",
                comment: "Display name for NuGet package manager"
            )
        case .opam:
            String(
                localized: "lsp.registry.package-manager-type.opam",
                defaultValue: "Opam",
                comment: "Display name for Opam package manager"
            )
        case .composer:
            String(
                localized: "lsp.registry.package-manager-type.composer",
                defaultValue: "Composer",
                comment: "Display name for Composer package manager"
            )
        case .sourceBuild:
            String(
                localized: "lsp.registry.package-manager-type.build-from-source",
                defaultValue: "Build From Source",
                comment: "Display name for building language server from source"
            )
        case .github:
            String(
                localized: "lsp.registry.package-manager-type.download-from-github",
                defaultValue: "Download From GitHub",
                comment: "Display name for downloading language server from GitHub"
            )
        }
    }
}
