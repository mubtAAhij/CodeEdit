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
            String(localized: "lsp.error.unknown", defaultValue: "Unknown error occurred", comment: "Generic unknown error message")
        case .packageManagerNotInstalled:
            String(localized: "lsp.error.not-installed", defaultValue: "The required package manager is not installed.", comment: "Error when package manager is missing")
        case .initializationFailed:
            String(localized: "lsp.error.init-failed", defaultValue: "Installation directory initialization failed.", comment: "Error when install directory cannot be created")
        case .installationFailed:
            String(localized: "lsp.error.install-failed", defaultValue: "Package installation failed.", comment: "Error when package installation fails")
        case .invalidConfiguration:
            String(localized: "lsp.error.invalid-config", defaultValue: "The package registry contained an invalid installation configuration.", comment: "Error when package config is invalid")
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
