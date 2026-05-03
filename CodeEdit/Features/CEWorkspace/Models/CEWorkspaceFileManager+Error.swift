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
                return String(localized: "workspace.file.error.file-not-found", defaultValue: "File not found", comment: "Error message when a file cannot be found")
            case .fileNotIndexed:
                return String(localized: "workspace.file.error.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "Error message when a file is not indexed in CodeEdit")
            case .originFileNotFound:
                return String(localized: "workspace.file.error.origin-file-not-found", defaultValue: "Failed to find origin file", comment: "Error message when the origin file for an operation cannot be found")
            case .destinationFileExists:
                return String(localized: "workspace.file.error.destination-exists", defaultValue: "Destination already exists", comment: "Error message when attempting to create or move a file to a location that already exists")
            case .invalidFileName:
                return String(localized: "workspace.file.error.invalid-file-name", defaultValue: "Invalid file name", comment: "Error message when a file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "workspace.file.error.reopen-workspace", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion to reopen the workspace")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "workspace.file.error.file-may-have-moved", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion when a file may have moved")
            case .destinationFileExists:
                return String(localized: "workspace.file.error.use-different-name", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion when destination file exists")
            case .invalidFileName:
                return String(localized: "workspace.file.error.file-name-constraints", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion explaining file name constraints")
            }
        }
    }
}
