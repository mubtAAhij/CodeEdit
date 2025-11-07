//
//  PackageManagerError.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/12/25.
//

import Foundation

enum PackageManagerError: Error, LocalizedError {
    case unknown
    case packageManagerNotInstalled
    case initializationFailed(String)
    case installationFailed(String)
    case invalidConfiguration

    var errorDescription: String? {
        switch self {
        case .unknown:
            return String(
                localized: "lsp.package-manager.error.unknown",
                defaultValue: "Unknown error occurred",
                comment: "Error message for unknown package manager error"
            )
        case .packageManagerNotInstalled:
            return String(
                localized: "lsp.package-manager.error.not-installed",
                defaultValue: "The required package manager is not installed.",
                comment: "Error message when package manager is not installed"
            )
        case .initializationFailed:
            return String(
                localized: "lsp.package-manager.error.initialization-failed",
                defaultValue: "Installation directory initialization failed.",
                comment: "Error message when installation directory initialization fails"
            )
        case .installationFailed:
            return String(
                localized: "lsp.package-manager.error.installation-failed",
                defaultValue: "Package installation failed.",
                comment: "Error message when package installation fails"
            )
        case .invalidConfiguration:
            return String(
                localized: "lsp.package-manager.error.invalid-configuration",
                defaultValue: "The package registry contained an invalid installation configuration.",
                comment: "Error message when package registry has invalid configuration"
            )
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            nil
        case .packageManagerNotInstalled:
            nil
        case .initializationFailed(let string):
            string
        case .installationFailed(let string):
            string
        case .invalidConfiguration:
            nil
        }
    }
}
