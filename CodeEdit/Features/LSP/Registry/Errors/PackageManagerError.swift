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
            String(localized: "unknown_error_occurred", comment: "Unknown package manager error message")
        case .packageManagerNotInstalled:
            String(localized: "package_manager_not_installed", comment: "Package manager not installed error message")
        case .initializationFailed:
            String(localized: "installation_directory_init_failed", comment: "Installation directory initialization failed error message")
        case .installationFailed:
            String(localized: "package_installation_failed", comment: "Package installation failed error message")
        case .invalidConfiguration:
            String(localized: "invalid_installation_configuration", comment: "Invalid installation configuration error message")
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
