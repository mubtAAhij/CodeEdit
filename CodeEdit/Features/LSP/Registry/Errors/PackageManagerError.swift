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
            String(localized: "lsp.package-manager.error.unknown", defaultValue: "Unknown error occurred", comment: "Unknown package manager error message")
        case .packageManagerNotInstalled:
            String(localized: "lsp.package-manager.error.not-installed", defaultValue: "The required package manager is not installed.", comment: "Package manager not installed error message")
        case .initializationFailed:
            String(localized: "lsp.package-manager.error.init-failed", defaultValue: "Installation directory initialization failed.", comment: "Installation directory initialization error message")
        case .installationFailed:
            String(localized: "lsp.package-manager.error.install-failed", defaultValue: "Package installation failed.", comment: "Package installation error message")
        case .invalidConfiguration:
            String(localized: "lsp.package-manager.error.invalid-config", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Invalid configuration error message")
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
