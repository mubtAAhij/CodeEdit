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
                return String(localized: "ce-workspace.file-management.error.file-not-found.title", defaultValue: "File not found", comment: "Error title when a file cannot be found")
            case .fileNotIndexed:
                return String(localized: "ce-workspace.file-management.error.file-not-found-in-codeedit.title", defaultValue: "File not found in CodeEdit", comment: "Error title when a file is missing from CodeEdit workspace index")
            case .originFileNotFound:
                return String(localized: "ce-workspace.file-management.error.failed-to-find-origin-file.title", defaultValue: "Failed to find origin file", comment: "Error title when source file cannot be located for an operation")
            case .destinationFileExists:
                return String(localized: "ce-workspace.file-management.error.destination-already-exists.title", defaultValue: "Destination already exists", comment: "Error title when target destination already has a file")
            case .invalidFileName:
                return String(localized: "ce-workspace.file-management.error.invalid-file-name.title", defaultValue: "Invalid file name", comment: "Error title when provided file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "ce-workspace.file-management.error.file-not-found.recovery-suggestion", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion when file is not found")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "ce-workspace.file-management.error.file-moved-during-operation.recovery-suggestion", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion when file may have moved while operation was running")
            case .destinationFileExists:
                return String(localized: "ce-workspace.file-management.error.destination-conflict.recovery-suggestion", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion when destination conflicts with an existing file")
            case .invalidFileName:
                return String(localized: "ce-workspace.file-management.error.invalid-file-name.recovery-suggestion", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion describing file name rules")
            }
        }
    }
}
