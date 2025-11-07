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
            String(localized: "lsp.registry.error.installation-running", defaultValue: "A package is already being installed.", comment: "Error message when another package is already being installed")
        case .invalidResponse(let statusCode):
            let code = statusCode
            return String(localized: "lsp.registry.error.invalid-response", defaultValue: "Invalid response received: \(code)", comment: "Error message for invalid HTTP response")
        case .downloadFailed(let url, _):
            let urlString = url
            return String(localized: "lsp.registry.error.download-failed", defaultValue: "Download for \(urlString) error.", comment: "Error message when download fails")
        case .maxRetriesExceeded(let url, _):
            "Maximum retries exceeded for url: \(url)"
        case .writeFailed:
            "Failed to write to file."
        case .failedToSaveRegistryCache:
            "Failed to write to registry cache."
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
