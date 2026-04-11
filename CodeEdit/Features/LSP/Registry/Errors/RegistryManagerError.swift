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
            String(localized: "registry-manager-error.installation-running", defaultValue: "A package is already being installed.", comment: "Package installation already running error description")
        case .invalidResponse(let statusCode):
            "Invalid response received: \(statusCode)"
        case .downloadFailed(let url, _):
            String(format: String(localized: "registry-manager-error.download-failed", defaultValue: "Download for %@ error.", comment: "Download failed error description"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "registry-manager-error.max-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Maximum retries exceeded error description"), url.absoluteString)
        case .writeFailed:
            String(localized: "registry-manager-error.write-failed", defaultValue: "Failed to write to file.", comment: "Failed to write to file error description")
        case .failedToSaveRegistryCache:
            String(localized: "registry-manager-error.save-cache-failed", defaultValue: "Failed to write to registry cache.", comment: "Failed to write to registry cache error description")
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
