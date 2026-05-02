//
//  CEWorkspaceFileManager+Error.swift
//  CodeEdit
//
//  Created by Khan Winter on 1/13/25.
//

import Foundation

extension CEWorkspaceFileManager {
    /// Localized errors related to actions in the file manager.
    /// These errors are suitable for presentation using `NSAlert(error:)`.
    enum FileManagerError: LocalizedError {
        case fileNotFound
        case fileNotIndexed
        case originFileNotFound
        case destinationFileExists
        case invalidFileName

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return String(localized: "workspace.error.file-not-found", defaultValue: "File not found", comment: "Error when file is not found")
            case .fileNotIndexed:
                return String(localized: "workspace.error.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "Error when file is not indexed")
            case .originFileNotFound:
                return String(localized: "workspace.error.origin-not-found", defaultValue: "Failed to find origin file", comment: "Error when origin file is not found")
            case .destinationFileExists:
                return String(localized: "workspace.error.destination-exists", defaultValue: "Destination already exists", comment: "Error when destination already exists")
            case .invalidFileName:
                return String(localized: "workspace.error.invalid-name", defaultValue: "Invalid file name", comment: "Error for invalid file name")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "workspace.error.reindex-suggestion", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion for file not indexed")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "workspace.error.retry-suggestion", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion for file not found")
            case .destinationFileExists:
                return String(localized: "workspace.error.rename-suggestion", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion for destination exists")
            case .invalidFileName:
                return String(localized: "workspace.error.filename-rules", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion for invalid file name")
            }
        }
    }
}
