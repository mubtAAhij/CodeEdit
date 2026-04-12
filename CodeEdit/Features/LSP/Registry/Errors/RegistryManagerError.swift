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
            String(localized: "lsp.installation-running", defaultValue: "A package is already being installed.", comment: "Installation running error")
        case .invalidResponse(let statusCode):
            "Invalid response received: \(statusCode)"
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.download-failed", defaultValue: "Download for %@ error.", comment: "Download failed error"), url.absoluteString)
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.max-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Max retries exceeded error"), url.absoluteString)
        case .writeFailed:
            String(localized: "lsp.write-failed", defaultValue: "Failed to write to file.", comment: "Write failed error")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.failed-to-save-cache", defaultValue: "Failed to write to registry cache.", comment: "Failed to save registry cache error")
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
