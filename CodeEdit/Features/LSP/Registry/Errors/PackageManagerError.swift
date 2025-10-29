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
            String(localized: "Unknown error occurred", comment: "Error description for unknown error")
        case .packageManagerNotInstalled:
            String(localized: "The required package manager is not installed.", comment: "Error description when package manager is not installed")
        case .initializationFailed:
            String(localized: "Installation directory initialization failed.", comment: "Error description when installation directory initialization fails")
        case .installationFailed:
            String(localized: "Package installation failed.", comment: "Error description when package installation fails")
        case .invalidConfiguration:
            String(localized: "The package registry contained an invalid installation configuration.", comment: "Error description for invalid configuration")
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
