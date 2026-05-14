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
                return String(localized: "workspace.file-manager.error.file-not-found", defaultValue: "File not found", comment: "Error message when file is not found")
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.error.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "Error message when file is not indexed in workspace")
            case .originFileNotFound:
                return String(localized: "workspace.file-manager.error.origin-not-found", defaultValue: "Failed to find origin file", comment: "Error message when origin file cannot be found")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.error.destination-exists", defaultValue: "Destination already exists", comment: "Error message when destination file already exists")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.error.invalid-name", defaultValue: "Invalid file name", comment: "Error message when file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.recovery.reopen-workspace", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion for file not indexed error")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "workspace.file-manager.recovery.file-moved", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion for file not found error")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.recovery.destination-exists", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion for destination exists error")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.recovery.invalid-name", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion for invalid file name error")
            }
        }
    }
}
