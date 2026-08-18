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
            String(
                localized: "lsp.registry.package-manager-error.unknown-error-occurred",
                defaultValue: "Unknown error occurred",
                comment: "Generic fallback package manager error message"
            )
        case .packageManagerNotInstalled:
            String(
                localized: "lsp.registry.package-manager-error.package-manager-not-installed",
                defaultValue: "The required package manager is not installed.",
                comment: "Error message when required package manager binary is unavailable"
            )
        case .initializationFailed:
            String(
                localized: "lsp.registry.package-manager-error.install-directory-init-failed",
                defaultValue: "Installation directory initialization failed.",
                comment: "Error message when installation directory initialization fails"
            )
        case .installationFailed:
            String(
                localized: "lsp.registry.package-manager-error.package-installation-failed",
                defaultValue: "Package installation failed.",
                comment: "Error message when package installation fails"
            )
        case .invalidConfiguration:
            String(
                localized: "lsp.registry.package-manager-error.invalid-installation-configuration",
                defaultValue: "The package registry contained an invalid installation configuration.",
                comment: "Error message when registry installation configuration is invalid"
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
