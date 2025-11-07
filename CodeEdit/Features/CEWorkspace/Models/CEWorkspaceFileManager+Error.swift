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
                return String(
                    localized: "file-manager-error.file-not-found",
                    defaultValue: "File not found",
                    comment: "Error message when file is not found"
                )
            case .fileNotIndexed:
                return String(
                    localized: "file-manager-error.file-not-indexed",
                    defaultValue: "File not found in CodeEdit",
                    comment: "Error message when file is not indexed"
                )
            case .originFileNotFound:
                return String(
                    localized: "file-manager-error.origin-file-not-found",
                    defaultValue: "Failed to find origin file",
                    comment: "Error message when origin file is not found"
                )
            case .destinationFileExists:
                return String(
                    localized: "file-manager-error.destination-already-exists",
                    defaultValue: "Destination already exists",
                    comment: "Error message when destination file already exists"
                )
            case .invalidFileName:
                return String(
                    localized: "file-manager-error.invalid-file-name",
                    defaultValue: "Invalid file name",
                    comment: "Error message when file name is invalid"
                )
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(
                    localized: "file-manager-error.reopen-workspace-suggestion",
                    defaultValue: "Reopen the workspace to reindex the file system.",
                    comment: "Recovery suggestion to reopen workspace"
                )
            case .fileNotFound, .originFileNotFound:
                return String(
                    localized: "file-manager-error.file-moved-suggestion",
                    defaultValue: "The file may have moved during the operation, try again.",
                    comment: "Recovery suggestion when file may have moved"
                )
            case .destinationFileExists:
                return String(
                    localized: "file-manager-error.use-different-name-suggestion",
                    defaultValue: "Use a different file name or remove the conflicting file.",
                    comment: "Recovery suggestion to use different file name"
                )
            case .invalidFileName:
                return String(
                    localized: "file-manager-error.invalid-file-name-suggestion",
                    defaultValue: "File names must not contain the : character and be less than 256 characters.",
                    comment: "Recovery suggestion for invalid file name"
                )
            }
        }
    }
}
