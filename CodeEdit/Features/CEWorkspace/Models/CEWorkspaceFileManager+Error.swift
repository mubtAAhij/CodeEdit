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
                return String(localized: "file-manager.error.file-not-found", defaultValue: "File not found", comment: "Error when a file cannot be found")
            case .fileNotIndexed:
                return String(localized: "file-manager.error.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "Error when a file is not indexed in the workspace")
            case .originFileNotFound:
                return String(localized: "file-manager.error.origin-not-found", defaultValue: "Failed to find origin file", comment: "Error when the origin file cannot be found during an operation")
            case .destinationFileExists:
                return String(localized: "file-manager.error.destination-exists", defaultValue: "Destination already exists", comment: "Error when destination file already exists")
            case .invalidFileName:
                return String(localized: "file-manager.error.invalid-name", defaultValue: "Invalid file name", comment: "Error when file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "file-manager.recovery.reindex", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion for file not indexed error")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file-manager.recovery.file-moved", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion when file may have moved")
            case .destinationFileExists:
                return String(localized: "file-manager.recovery.destination-exists", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion when destination already exists")
            case .invalidFileName:
                return String(localized: "file-manager.recovery.invalid-name", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion for invalid file name")
            }
        }
    }
}
