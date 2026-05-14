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
            String(localized: "lsp.error.unknown", defaultValue: "Unknown error occurred", comment: "LSP package manager unknown error message")
        case .packageManagerNotInstalled:
            String(localized: "lsp.error.package-manager-not-installed", defaultValue: "The required package manager is not installed.", comment: "LSP package manager not installed error message")
        case .initializationFailed:
            String(localized: "lsp.error.initialization-failed", defaultValue: "Installation directory initialization failed.", comment: "LSP installation directory initialization error message")
        case .installationFailed:
            String(localized: "lsp.error.installation-failed", defaultValue: "Package installation failed.", comment: "LSP package installation error message")
        case .invalidConfiguration:
            String(localized: "lsp.error.invalid-configuration", defaultValue: "The package registry contained an invalid installation configuration.", comment: "LSP invalid configuration error message")
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
