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
            String(localized: "lsp.registry.error.package-already-being-installed", defaultValue: "A package is already being installed.", comment: "Error message shown when another package installation is already running")
        case .invalidResponse(let statusCode):
            "Invalid response received: \(statusCode)"
        case .downloadFailed(let url, _):
            "Download for \(url) error."
        case .maxRetriesExceeded(let url, _):
            "Maximum retries exceeded for url: \(url)"
        case .writeFailed:
            String(localized: "lsp.registry.error.failed-to-write-file", defaultValue: "Failed to write to file.", comment: "Error message shown when writing downloaded data to disk fails")
        case .failedToSaveRegistryCache:
            String(localized: "lsp.registry.error.failed-to-write-registry-cache", defaultValue: "Failed to write to registry cache.", comment: "Error message shown when persisting registry cache fails")
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
