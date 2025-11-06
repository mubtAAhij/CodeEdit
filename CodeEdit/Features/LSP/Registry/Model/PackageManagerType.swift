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
            String(localized: "lsp.package-manager.go", defaultValue: "Go", comment: "Go package manager name")
        case .pip:
            String(localized: "lsp.package-manager.pip", defaultValue: "Pip", comment: "Pip package manager name")
        case .gem:
            String(localized: "lsp.package-manager.gem", defaultValue: "Gem", comment: "Gem package manager name")
        case .nuget:
            String(localized: "lsp.package-manager.nuget", defaultValue: "Nuget", comment: "Nuget package manager name")
        case .opam:
            String(localized: "lsp.package-manager.opam", defaultValue: "Opam", comment: "Opam package manager name")
        case .composer:
            String(localized: "lsp.package-manager.composer", defaultValue: "Composer", comment: "Composer package manager name")
        case .sourceBuild:
            String(localized: "lsp.package-manager.build-from-source", defaultValue: "Build From Source", comment: "Build from source package manager option")
        case .github:
            String(localized: "lsp.package-manager.download-github", defaultValue: "Download From GitHub", comment: "Download from GitHub package manager option")
        }
    }
}
