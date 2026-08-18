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
            String(localized: "lsp.package-manager-error.unknown-error-occurred", defaultValue: "Unknown error occurred", comment: "Fallback error description for unknown package manager error")
        case .packageManagerNotInstalled:
            String(localized: "lsp.package-manager-error.required-package-manager-not-installed", defaultValue: "The required package manager is not installed.", comment: "Error description when required package manager is missing")
        case .initializationFailed:
            String(localized: "lsp.package-manager-error.installation-directory-initialization-failed", defaultValue: "Installation directory initialization failed.", comment: "Error description when initialization of installation directory fails")
        case .installationFailed:
            String(localized: "lsp.package-manager-error.package-installation-failed", defaultValue: "Package installation failed.", comment: "Error description when package installation fails")
        case .invalidConfiguration:
            String(localized: "lsp.package-manager-error.invalid-installation-configuration", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Error description when package registry contains invalid installation configuration")
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
