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
            String(localized: "lsp.error.installation_running", comment: "Error when package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(localized: "lsp.error.invalid_response \(statusCode)", comment: "Error for invalid HTTP response")
        case .downloadFailed(let url, _):
            String(localized: "lsp.error.download_failed \(url)", comment: "Error when download fails")
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
