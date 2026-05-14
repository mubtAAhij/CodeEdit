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
            String(localized: "lsp.package-manager.npm", defaultValue: "NPM", comment: "Package manager name for JavaScript/Node.js")
        case .cargo:
            String(localized: "lsp.package-manager.cargo", defaultValue: "Cargo", comment: "Package manager name for Rust")
        case .golang:
            String(localized: "lsp.package-manager.go", defaultValue: "Go", comment: "Package manager name for Go")
        case .pip:
            String(localized: "lsp.package-manager.pip", defaultValue: "Pip", comment: "Package manager name for Python")
        case .gem:
            String(localized: "lsp.package-manager.gem", defaultValue: "Gem", comment: "Package manager name for Ruby")
        case .nuget:
            String(localized: "lsp.package-manager.nuget", defaultValue: "Nuget", comment: "Package manager name for C#/.NET")
        case .opam:
            String(localized: "lsp.package-manager.opam", defaultValue: "Opam", comment: "Package manager name for OCaml")
        case .composer:
            String(localized: "lsp.package-manager.composer", defaultValue: "Composer", comment: "Package manager name for PHP")
        case .sourceBuild:
            String(localized: "lsp.package-manager.source-build", defaultValue: "Build From Source", comment: "Installation method: building from source code")
        case .github:
            String(localized: "lsp.package-manager.github-download", defaultValue: "Download From GitHub", comment: "Installation method: downloading binary from GitHub")
        }
    }
}
