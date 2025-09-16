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
            String(localized: "npm_package_manager", comment: "Display name for NPM package manager")
        case .cargo:
            String(localized: "cargo", comment: "Rust package manager name")
        case .golang:
            String(localized: "go", comment: "Go package manager name")
        case .pip:
            String(localized: "pip", comment: "Python package manager name")
        case .gem:
            String(localized: "gem", comment: "Ruby package manager name")
        case .nuget:
            String(localized: "nuget", comment: "C# package manager name")
        case .opam:
            String(localized: "opam", comment: "OCaml package manager name")
        case .composer:
            String(localized: "composer", comment: "PHP package manager name")
        case .sourceBuild:
            String(localized: "build_from_source", comment: "Package installation method")
        case .github:
            String(localized: "download_from_github", comment: "Package installation method")
        }
    }
}
