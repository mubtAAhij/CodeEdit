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
            String(localized: "package_manager.go", comment: "Package manager name")
        case .pip:
            String(localized: "package_manager.pip", comment: "Package manager name")
        case .gem:
            String(localized: "package_manager.gem", comment: "Package manager name")
        case .nuget:
            String(localized: "package_manager.nuget", comment: "Package manager name")
        case .opam:
            String(localized: "package_manager.opam", comment: "Package manager name")
        case .composer:
            String(localized: "package_manager.composer", comment: "Package manager name")
        case .sourceBuild:
            String(localized: "package_manager.build_from_source", comment: "Package manager name")
        case .github:
            String(localized: "package_manager.download_from_github", comment: "Package manager name")
        }
    }
}
