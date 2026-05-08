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
            String(localized: "lsp.packagemanager.npm", defaultValue: "NPM", comment: "NPM package manager")
        case .cargo:
            String(localized: "lsp.packagemanager.cargo", defaultValue: "Cargo", comment: "Cargo package manager")
        case .golang:
            String(localized: "lsp.packagemanager.go", defaultValue: "Go", comment: "Go package manager")
        case .pip:
            String(localized: "lsp.packagemanager.pip", defaultValue: "Pip", comment: "Pip package manager")
        case .gem:
            String(localized: "lsp.packagemanager.gem", defaultValue: "Gem", comment: "Gem package manager")
        case .nuget:
            String(localized: "lsp.packagemanager.nuget", defaultValue: "Nuget", comment: "Nuget package manager")
        case .opam:
            String(localized: "lsp.packagemanager.opam", defaultValue: "Opam", comment: "Opam package manager")
        case .composer:
            String(localized: "lsp.packagemanager.composer", defaultValue: "Composer", comment: "Composer package manager")
        case .sourceBuild:
            String(localized: "lsp.packagemanager.source-build", defaultValue: "Build From Source", comment: "Build from source option")
        case .github:
            String(localized: "lsp.packagemanager.github-download", defaultValue: "Download From GitHub", comment: "Download from GitHub option")
        }
    }
}
