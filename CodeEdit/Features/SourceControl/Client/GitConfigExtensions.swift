//
//  GitConfigExtensions.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/16/24.
//

import Foundation

/// Conformance of `Bool` to `GitConfigRepresentable`
///
/// This enables `Bool` values to be represented in Git configuration as
/// `true` or `false`.
extension Bool: GitConfigRepresentable {
    public init?(configValue: String) {
        switch configValue.lowercased() {
        case String(localized: "git.config.bool.true", defaultValue: "true", comment: "Git config boolean true value"): self = true
        case String(localized: "git.config.bool.false", defaultValue: "false", comment: "Git config boolean false value"): self = false
        default: return nil
        }
    }

    public var asConfigValue: String {
        self ? String(localized: "git.config.bool.true", defaultValue: "true", comment: "Git config boolean true value") : String(localized: "git.config.bool.false", defaultValue: "false", comment: "Git config boolean false value")
    }
}

/// Conformance of `String` to `GitConfigRepresentable`
///
/// This enables `String` values to be represented in Git configuration,
/// automatically escaping them with quotes.
extension String: GitConfigRepresentable {
    public init?(configValue: String) {
        self = configValue
    }

    public var asConfigValue: String {
        String(format: String(localized: "git.config.string.format", defaultValue: "\"%@\"", comment: "Git config string format with quotes"), self)
    }
}
