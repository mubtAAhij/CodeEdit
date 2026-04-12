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
            String(localized: "lsp.unknown-error", defaultValue: "Unknown error occurred", comment: "Unknown error")
        case .packageManagerNotInstalled:
            String(localized: "lsp.package-manager-not-installed", defaultValue: "The required package manager is not installed.", comment: "Package manager not installed error")
        case .initializationFailed:
            String(localized: "lsp.initialization-failed", defaultValue: "Installation directory initialization failed.", comment: "Initialization failed error")
        case .installationFailed:
            String(localized: "lsp.installation-failed", defaultValue: "Package installation failed.", comment: "Installation failed error")
        case .invalidConfiguration:
            String(localized: "lsp.invalid-configuration", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Invalid configuration error")
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
