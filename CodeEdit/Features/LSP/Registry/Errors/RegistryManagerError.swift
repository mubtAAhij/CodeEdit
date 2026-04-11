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
            String(localized: "lsp.registry.error.already-installing", defaultValue: "A package is already being installed.", comment: "Package already installing error")
        case .invalidResponse(let statusCode):
            "Invalid response received: \(statusCode)"
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry.error.download-failed", defaultValue: "Download for %@ error.", comment: "Download failed error"), url)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry.error.max-retries", defaultValue: "Maximum retries exceeded for url: %@", comment: "Max retries exceeded error"), url)
        case .writeFailed:
            String(localized: "lsp.registry.error.write-file-failed", defaultValue: "Failed to write to file.", comment: "Write to file failed error")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.error.write-cache-failed", defaultValue: "Failed to write to registry cache.", comment: "Write to cache failed error")
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
