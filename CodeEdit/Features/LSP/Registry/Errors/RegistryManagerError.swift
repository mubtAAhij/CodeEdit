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
            String(localized: "lsp.registry.error.installation.running", defaultValue: "A package is already being installed.", comment: "Installation already running error")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "lsp.registry.error.invalid.response", defaultValue: "Invalid response received: %d", comment: "Invalid response error"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry.error.download.failed", defaultValue: "Download for %@ error.", comment: "Download failed error"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry.error.max.retries", defaultValue: "Maximum retries exceeded for url: %@", comment: "Max retries exceeded error"), url.absoluteString)
        case .writeFailed:
            String(localized: "lsp.registry.error.write.failed", defaultValue: "Failed to write to file.", comment: "Write to file failed error")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.error.cache.failed", defaultValue: "Failed to write to registry cache.", comment: "Registry cache write failed error")
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
