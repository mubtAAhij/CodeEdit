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
            String(localized: "lsp.error.already-installing", defaultValue: "A package is already being installed.", comment: "Error message when trying to install while another installation is in progress")
        case .invalidResponse(let statusCode):
            String(localized: "lsp.error.invalid-response", defaultValue: "Invalid response received: \(statusCode)", comment: "Error message for invalid HTTP response with status code")
        case .downloadFailed(let url, _):
            String(localized: "lsp.error.download-failed", defaultValue: "Download for \(url) error.", comment: "Error message when download fails for a URL")
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
