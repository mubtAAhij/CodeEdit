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
            String(localized: "Go", comment: "Go package manager")
        case .pip:
            String(localized: "Pip", comment: "Python package manager")
        case .gem:
            String(localized: "Gem", comment: "Ruby package manager")
        case .nuget:
            String(localized: "Nuget", comment: "C# package manager")
        case .opam:
            String(localized: "Opam", comment: "OCaml package manager")
        case .composer:
            String(localized: "Composer", comment: "PHP package manager")
        case .sourceBuild:
            String(localized: "Build From Source", comment: "Build from source option")
        case .github:
            String(localized: "Download From GitHub", comment: "Download from GitHub option")
        }
    }
}
