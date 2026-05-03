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
            String(localized: "registry.error.installation_running", defaultValue: "A package is already being installed.", comment: "Installation already running error")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "registry.error.invalid_response", defaultValue: "Invalid response received: %d", comment: "Invalid response error"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "registry.error.download_failed", defaultValue: "Download for %@ error.", comment: "Download failed error"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "registry.error.max_retries", defaultValue: "Maximum retries exceeded for url: %@", comment: "Maximum retries exceeded error"), url.absoluteString)
        case .writeFailed:
            String(localized: "registry.error.write_failed", defaultValue: "Failed to write to file.", comment: "Write failed error")
        case .failedToSaveRegistryCache:
            String(localized: "registry.error.cache_save_failed", defaultValue: "Failed to write to registry cache.", comment: "Cache save failed error")
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
