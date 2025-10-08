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
            String(localized: "package_manager.error.unknown", comment: "Generic error message for package manager failures")
        case .packageManagerNotInstalled:
            String(localized: "package_manager.error.not_installed", comment: "Error message when package manager is not installed")
        case .initializationFailed:
            String(localized: "package_manager.error.directory_init_failed", comment: "Error message when installation directory cannot be initialized")
        case .installationFailed:
            String(localized: "package_manager.error.installation_failed", comment: "Error message when package installation fails")
        case .invalidConfiguration:
            String(localized: "package_manager.error.invalid_configuration", comment: "Error message when package registry has invalid configuration")
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
