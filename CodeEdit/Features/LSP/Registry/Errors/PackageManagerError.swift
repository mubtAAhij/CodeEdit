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
            String(localized: "packageManagerError.unknown", comment: "Error message")
        case .packageManagerNotInstalled:
            String(localized: "packageManagerError.notInstalled", comment: "Error message")
        case .initializationFailed:
            String(localized: "packageManagerError.initializationFailed", comment: "Error message")
        case .installationFailed:
            String(localized: "packageManagerError.installationFailed", comment: "Error message")
        case .invalidConfiguration:
            String(localized: "packageManagerError.invalidConfiguration", comment: "Error message")
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
