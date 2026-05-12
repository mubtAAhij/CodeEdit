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
            String(localized: "registry-manager.error.installation-running", defaultValue: "A package is already being installed.", comment: "Error when a package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "registry-manager.error.invalid-response", defaultValue: "Invalid response received: %d", comment: "Error for invalid HTTP response, %d is status code"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "registry-manager.error.download-failed", defaultValue: "Download for %@ error.", comment: "Error when download fails, %@ is the URL"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "registry-manager.error.max-retries", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error when max retries exceeded, %@ is the URL"), url.absoluteString)
        case .writeFailed:
            String(localized: "registry-manager.error.write-failed", defaultValue: "Failed to write to file.", comment: "Error when file write fails")
        case .failedToSaveRegistryCache:
            String(localized: "registry-manager.error.cache-write-failed", defaultValue: "Failed to write to registry cache.", comment: "Error when registry cache write fails")
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
