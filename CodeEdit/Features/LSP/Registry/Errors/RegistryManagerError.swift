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
            String(localized: "lsp.registry.error.installation-running", defaultValue: "A package is already being installed.", comment: "Error when another package is installing")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "lsp.registry.error.invalid-response", defaultValue: "Invalid response received: %d", comment: "Error for invalid HTTP response"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry.error.download-error", defaultValue: "Download for %@ error.", comment: "Error downloading from URL"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry.error.max-retries", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error when max retries exceeded"), url.absoluteString)
        case .writeFailed:
            String(localized: "lsp.registry.error.file-write", defaultValue: "Failed to write to file.", comment: "Error writing to file")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.error.cache-write", defaultValue: "Failed to write to registry cache.", comment: "Error writing to cache")
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
