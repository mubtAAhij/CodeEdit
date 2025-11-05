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
            String(localized: "package-manager.error.unknown", defaultValue: "Unknown error occurred", comment: "Unknown package manager error")
        case .packageManagerNotInstalled:
            String(localized: "package-manager.error.not-installed", defaultValue: "The required package manager is not installed.", comment: "Error when package manager is not installed")
        case .initializationFailed:
            String(localized: "package-manager.error.initialization-failed", defaultValue: "Installation directory initialization failed.", comment: "Error when installation directory initialization fails")
        case .installationFailed:
            String(localized: "package-manager.error.installation-failed", defaultValue: "Package installation failed.", comment: "Error when package installation fails")
        case .invalidConfiguration:
            String(localized: "package-manager.error.invalid-configuration", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Error when package configuration is invalid")
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
