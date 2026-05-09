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
            String(localized: "lsp.package-manager.npm", defaultValue: "NPM", comment: "Package manager name for NPM (Node Package Manager)")
        case .cargo:
            String(localized: "lsp.package-manager.cargo", defaultValue: "Cargo", comment: "Package manager name for Cargo (Rust)")
        case .golang:
            String(localized: "lsp.package-manager.go", defaultValue: "Go", comment: "Package manager name for Go")
        case .pip:
            String(localized: "lsp.package-manager.pip", defaultValue: "Pip", comment: "Package manager name for Pip (Python)")
        case .gem:
            String(localized: "lsp.package-manager.gem", defaultValue: "Gem", comment: "Package manager name for Gem (Ruby)")
        case .nuget:
            String(localized: "lsp.package-manager.nuget", defaultValue: "Nuget", comment: "Package manager name for Nuget (C#)")
        case .opam:
            String(localized: "lsp.package-manager.opam", defaultValue: "Opam", comment: "Package manager name for Opam (OCaml)")
        case .composer:
            String(localized: "lsp.package-manager.composer", defaultValue: "Composer", comment: "Package manager name for Composer (PHP)")
        case .sourceBuild:
            String(localized: "lsp.package-manager.build-from-source", defaultValue: "Build From Source", comment: "Package manager name for building from source")
        case .github:
            String(localized: "lsp.package-manager.download-from-github", defaultValue: "Download From GitHub", comment: "Package manager name for downloading from GitHub")
        }
    }
}
