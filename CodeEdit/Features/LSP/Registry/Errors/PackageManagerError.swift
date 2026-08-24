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
            String(localized: "lsp.package-manager.error.unknown", defaultValue: "Unknown error occurred", comment: "Fallback package manager error message when no specific reason is available")
        case .packageManagerNotInstalled:
            String(localized: "lsp.package-manager.error.not-installed", defaultValue: "The required package manager is not installed.", comment: "Error shown when required package manager binary is missing")
        case .initializationFailed:
            String(localized: "lsp.package-manager.error.directory-init-failed", defaultValue: "Installation directory initialization failed.", comment: "Error shown when installation directory setup fails")
        case .installationFailed:
            String(localized: "lsp.package-manager.error.installation-failed", defaultValue: "Package installation failed.", comment: "Error shown when package manager installation command fails")
        case .invalidConfiguration:
            String(localized: "lsp.package-manager.error.invalid-installation-configuration", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Error shown when registry installation metadata is invalid")
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            nil
        case .packageManagerNotInstalled:
            nil
        case let .initializationFailed(string):
            string
        case let .installationFailed(string):
            string
        case .invalidConfiguration:
            nil
        }
    }
}
