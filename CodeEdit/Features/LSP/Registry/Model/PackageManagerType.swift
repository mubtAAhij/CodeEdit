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
            String(localized: "packageManager.go", comment: "Package manager name")
        case .pip:
            String(localized: "packageManager.pip", comment: "Package manager name")
        case .gem:
            String(localized: "packageManager.gem", comment: "Package manager name")
        case .nuget:
            String(localized: "packageManager.nuget", comment: "Package manager name")
        case .opam:
            String(localized: "packageManager.opam", comment: "Package manager name")
        case .composer:
            String(localized: "packageManager.composer", comment: "Package manager name")
        case .sourceBuild:
            String(localized: "packageManager.buildFromSource", comment: "Package manager name")
        case .github:
            String(localized: "packageManager.downloadFromGithub", comment: "Package manager name")
        }
    }
}
