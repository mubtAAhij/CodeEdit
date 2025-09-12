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
            String(localized: "package_already_being_installed", comment: "Error message when attempting to install a package while another installation is in progress")
        case .invalidResponse(let statusCode):
            String(localized: "invalid_response_received", comment: "Error message for invalid HTTP response with status code").replacingOccurrences(of: "%d", with: "\(statusCode)")
        case .downloadFailed(let url, _):
            String(localized: "download_error", comment: "Error message for download failure with URL").replacingOccurrences(of: "%@", with: "\(url)")
        case .maxRetriesExceeded(let url, _):
            String(localized: "maximum_retries_exceeded", comment: "Error message when maximum retries exceeded for URL").replacingOccurrences(of: "%@", with: "\(url)")
        case .writeFailed:
            String(localized: "failed_to_write_to_file", comment: "Error message for file write failure")
        case .failedToSaveRegistryCache:
            String(localized: "failed_to_write_to_registry_cache", comment: "Error message for registry cache write failure")
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
