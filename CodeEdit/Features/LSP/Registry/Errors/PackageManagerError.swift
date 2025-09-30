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
            String(localized: "package_manager.error.unknown", comment: "Unknown package manager error message")
        case .packageManagerNotInstalled:
            String(localized: "package_manager.error.not_installed", comment: "Error when package manager is not installed")
        case .initializationFailed:
            String(localized: "package_manager.error.initialization_failed", comment: "Error when installation directory initialization fails")
        case .installationFailed:
            String(localized: "package_manager.error.installation_failed", comment: "Error when package installation fails")
        case .invalidConfiguration:
            String(localized: "package_manager.error.invalid_configuration", comment: "Error when package registry has invalid configuration")
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
