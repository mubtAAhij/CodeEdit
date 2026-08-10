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
            String(localized: "lsp.registry.error.installation-running", defaultValue: "A package is already being installed.", comment: "Error shown when another package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "lsp.registry.error.invalid-response", defaultValue: "Invalid response received: %d", comment: "Error shown when registry returns an invalid HTTP status code"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry.error.download-failed", defaultValue: "Download for %@ error.", comment: "Error shown when package download fails"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry.error.max-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error shown when retry limit is reached for a package URL"), url.absoluteString)
        case .writeFailed:
            String(localized: "lsp.registry.error.write-failed", defaultValue: "Failed to write to file.", comment: "Error shown when writing a downloaded file fails")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.error.failed-to-save-cache", defaultValue: "Failed to write to registry cache.", comment: "Error shown when writing the registry cache fails")
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
