//
//  RegistryManagerError.swift
//  CodeEdit
//
//  Created by Abe Malla on 5/12/25.
//

import Foundation

enum RegistryManagerError: Error, LocalizedError {
    case installationRunning
    case invalidResponse(statusCode: Int)
    case downloadFailed(url: URL, error: Error)
    case maxRetriesExceeded(url: URL, lastError: Error)
    case writeFailed(error: Error)
    case failedToSaveRegistryCache

    var errorDescription: String? {
        switch self {
        case .installationRunning:
            String(localized: "lsp.registry.registry-manager-error.package-already-installing", defaultValue: "A package is already being installed.", comment: "Error message when another package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "lsp.registry.registry-manager-error.invalid-response-received", defaultValue: "Invalid response received: %d", comment: "Error message when registry HTTP response status code is invalid"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry.registry-manager-error.download-error", defaultValue: "Download for %@ error.", comment: "Error message when downloading package data fails for a URL"), "\(url)")
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry.registry-manager-error.maximum-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error message when retry limit is exceeded for a URL"), "\(url)")
        case .writeFailed:
            String(localized: "lsp.registry.registry-manager-error.failed-write-file", defaultValue: "Failed to write to file.", comment: "Error message when writing downloaded package data to file fails")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.registry-manager-error.failed-write-cache", defaultValue: "Failed to write to registry cache.", comment: "Error message when writing package metadata to registry cache fails")
        }
    }

    var failureReason: String? {
        switch self {
        case .installationRunning, .invalidResponse, .failedToSaveRegistryCache:
            return nil
        case .downloadFailed(_, let error), .maxRetriesExceeded(_, let error), .writeFailed(let error):
            return if let error = error as? LocalizedError {
                error.errorDescription
            } else {
                error.localizedDescription
            }
        }
    }
}
