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
            String(localized: "Unknown error occurred")
        case .packageManagerNotInstalled:
            String(localized: "The required package manager is not installed.")
        case .initializationFailed:
            String(localized: "Installation directory initialization failed.")
        case .installationFailed:
            String(localized: "Package installation failed.")
        case .invalidConfiguration:
            String(localized: "The package registry contained an invalid installation configuration.")
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
