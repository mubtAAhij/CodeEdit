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
            String(localized: "lsp.package-manager-type.npm", defaultValue: "NPM", comment: "Display name for the NPM package manager type.")
        case .cargo:
            String(localized: "lsp.package-manager-type.cargo", defaultValue: "Cargo", comment: "Display name for the Cargo package manager type.")
        case .golang:
            String(localized: "lsp.package-manager-type.go", defaultValue: "Go", comment: "Display name for the Go package manager type.")
        case .pip:
            String(localized: "lsp.package-manager-type.pip", defaultValue: "Pip", comment: "Display name for the Pip package manager type.")
        case .gem:
            String(localized: "lsp.package-manager-type.gem", defaultValue: "Gem", comment: "Display name for the RubyGems package manager type.")
        case .nuget:
            String(localized: "lsp.package-manager-type.nuget", defaultValue: "Nuget", comment: "Display name for the NuGet package manager type.")
        case .opam:
            String(localized: "lsp.package-manager-type.opam", defaultValue: "Opam", comment: "Display name for the Opam package manager type.")
        case .composer:
            String(localized: "lsp.package-manager-type.composer", defaultValue: "Composer", comment: "Display name for the Composer package manager type.")
        case .sourceBuild:
            String(localized: "lsp.package-manager-type.build-from-source", defaultValue: "Build From Source", comment: "Display name for package manager install method from source.")
        case .github:
            String(localized: "lsp.package-manager-type.download-from-github", defaultValue: "Download From GitHub", comment: "Display name for package manager install method from GitHub.")
        }
    }
}
