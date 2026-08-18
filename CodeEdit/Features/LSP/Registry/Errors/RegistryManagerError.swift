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
            String(localized: "lsp.registry-manager-error.package-already-installing", defaultValue: "A package is already being installed.", comment: "Error message when another package installation is already in progress")
        case .invalidResponse(let statusCode):
            String(format: String(localized: "lsp.registry-manager-error.invalid-response-received", defaultValue: "Invalid response received: %d", comment: "Error message when registry request returns invalid HTTP status code"), statusCode)
        case .downloadFailed(let url, _):
            String(format: String(localized: "lsp.registry-manager-error.download-error", defaultValue: "Download for %@ error.", comment: "Error message when download fails for a specific URL"), "\(url)")
        case .maxRetriesExceeded(let url, _):
            String(format: String(localized: "lsp.registry-manager-error.maximum-retries-exceeded", defaultValue: "Maximum retries exceeded for url: %@", comment: "Error message when download retries are exhausted for a specific URL"), "\(url)")
        case .writeFailed:
            String(localized: "lsp.registry-manager-error.failed-to-write-file", defaultValue: "Failed to write to file.", comment: "Error message when writing downloaded data to file fails")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry-manager-error.failed-to-write-registry-cache", defaultValue: "Failed to write to registry cache.", comment: "Error message when writing registry cache fails")
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
