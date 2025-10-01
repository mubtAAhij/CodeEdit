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
            String(localized: "package_manager.type.go", comment: "Go package manager name")
        case .pip:
            String(localized: "package_manager.type.pip", comment: "Python pip package manager name")
        case .gem:
            String(localized: "package_manager.type.gem", comment: "Ruby gem package manager name")
        case .nuget:
            String(localized: "package_manager.type.nuget", comment: ".NET NuGet package manager name")
        case .opam:
            String(localized: "package_manager.type.opam", comment: "OCaml Opam package manager name")
        case .composer:
            String(localized: "package_manager.type.composer", comment: "PHP Composer package manager name")
        case .sourceBuild:
            String(localized: "package_manager.type.build_from_source", comment: "Build from source package manager option")
        case .github:
            String(localized: "package_manager.download_from_github", comment: "Package manager type description for downloading from GitHub")
        }
    }
}
