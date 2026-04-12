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
            String(localized: "registry.installation-running", defaultValue: "A package is already being installed.", comment: "Error when a package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "registry.invalid-response", defaultValue: "Invalid response received: %d", comment: "Error for invalid HTTP response"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "registry.download-failed", defaultValue: "Download for %@ error.", comment: "Error when download fails"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "registry.max-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error when maximum retries exceeded"), url.absoluteString)
        case .writeFailed:
            String(localized: "registry.write-failed", defaultValue: "Failed to write to file.", comment: "Error when writing to file fails")
        case .failedToSaveRegistryCache:
            String(localized: "registry.cache-write-failed", defaultValue: "Failed to write to registry cache.", comment: "Error when writing to registry cache fails")
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
