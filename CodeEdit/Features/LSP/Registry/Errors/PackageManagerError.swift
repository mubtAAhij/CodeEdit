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
            String(localized: "error.package_manager.unknown", comment: "Error message")
        case .packageManagerNotInstalled:
            String(localized: "error.package_manager.not_installed", comment: "Error message")
        case .initializationFailed:
            String(localized: "error.package_manager.initialization_failed", comment: "Error message")
        case .installationFailed:
            String(localized: "error.package_manager.installation_failed", comment: "Error message")
        case .invalidConfiguration:
            String(localized: "error.package_manager.invalid_configuration", comment: "Error message")
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
