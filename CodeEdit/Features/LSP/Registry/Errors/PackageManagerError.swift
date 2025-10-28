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
            String(localized: "error.package_manager.unknown", comment: "Unknown error message")
        case .packageManagerNotInstalled:
            String(localized: "error.package_manager.not_installed", comment: "Package manager not installed error")
        case .initializationFailed:
            String(localized: "error.package_manager.init_failed", comment: "Initialization failed error")
        case .installationFailed:
            String(localized: "error.package_manager.install_failed", comment: "Installation failed error")
        case .invalidConfiguration:
            String(localized: "error.package_manager.invalid_config", comment: "Invalid configuration error")
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
