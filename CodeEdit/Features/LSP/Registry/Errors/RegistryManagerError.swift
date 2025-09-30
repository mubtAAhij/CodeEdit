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
            String(localized: "registry_manager.error.installation_running", comment: "Error message when package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(localized: "registry_manager.error.invalid_response", arguments: ["\(statusCode)"], comment: "Error message for invalid HTTP response with status code")
        case .downloadFailed(let url, _):
            String(localized: "registry_manager.error.download_failed", arguments: ["\(url)"], comment: "Error message for download failure with URL")
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
