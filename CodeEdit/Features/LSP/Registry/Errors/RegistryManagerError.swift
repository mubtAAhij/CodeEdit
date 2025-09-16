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
            String(localized: "package_already_being_installed", comment: "Error message when trying to install a package while another installation is in progress")
        case .invalidResponse(let statusCode):
            String(localized: "invalid_response_received", comment: "Error message for invalid HTTP response with status code")
        case .downloadFailed(let url, _):
            String(localized: "download_error", comment: "Error message when download fails for a specific URL")
        case .maxRetriesExceeded(let url, _):
            String(localized: "maximum_retries_exceeded", comment: "Error message when maximum retry attempts are exceeded for a URL")
        case .writeFailed:
            String(localized: "failed_to_write_file", comment: "Error message when file write operation fails")
        case .failedToSaveRegistryCache:
            String(localized: "failed_to_write_registry_cache", comment: "Error message when writing to registry cache fails")
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
