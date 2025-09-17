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
            String(localized: "package_installation_running", comment: "Package installation already running error message")
        case .invalidResponse(let statusCode):
            String(localized: "invalid_response_received", arguments: [statusCode], comment: "Invalid response received error message")
        case .downloadFailed(let url, _):
            String(localized: "download_error", arguments: [url], comment: "Download error message")
        case .maxRetriesExceeded(let url, _):
            String(localized: "max_retries_exceeded", arguments: [url.absoluteString], comment: "Error message when maximum retries exceeded")
        case .writeFailed:
            String(localized: "failed_write_file", comment: "Error message when file write fails")
        case .failedToSaveRegistryCache:
            String(localized: "failed_write_registry_cache", comment: "Error message when registry cache write fails")
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
