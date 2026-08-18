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
                    localized: "ce-workspace.file-manager.error.file-not-found.title",
                    defaultValue: "File not found",
                    comment: "Error title when a file cannot be found"
                )
            case .fileNotIndexed:
                return String(
                    localized: "ce-workspace.file-manager.error.file-not-found-in-codeedit.title",
                    defaultValue: "File not found in CodeEdit",
                    comment: "Error title when file is missing from workspace index"
                )
            case .originFileNotFound:
                return String(
                    localized: "ce-workspace.file-manager.error.failed-to-find-origin-file.title",
                    defaultValue: "Failed to find origin file",
                    comment: "Error title when source file lookup fails"
                )
            case .destinationFileExists:
                return String(
                    localized: "ce-workspace.file-manager.error.destination-already-exists.title",
                    defaultValue: "Destination already exists",
                    comment: "Error title when destination path already exists"
                )
            case .invalidFileName:
                return String(
                    localized: "ce-workspace.file-manager.error.invalid-file-name.title",
                    defaultValue: "Invalid file name",
                    comment: "Error title when provided file name is invalid"
                )
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(
                    localized: "ce-workspace.file-manager.error.file-not-found.recovery.reopen-workspace",
                    defaultValue: "Reopen the workspace to reindex the file system.",
                    comment: "Recovery suggestion to reopen workspace and reindex filesystem"
                )
            case .fileNotFound, .originFileNotFound:
                return String(
                    localized: "ce-workspace.file-manager.error.failed-to-find-origin-file.recovery.try-again",
                    defaultValue: "The file may have moved during the operation, try again.",
                    comment: "Recovery suggestion when origin file may have moved"
                )
            case .destinationFileExists:
                return String(
                    localized: "ce-workspace.file-manager.error.destination-already-exists.recovery.use-different-name",
                    defaultValue: "Use a different file name or remove the conflicting file.",
                    comment: "Recovery suggestion when destination conflicts with existing file"
                )
            case .invalidFileName:
                return String(
                    localized: "ce-workspace.file-manager.error.invalid-file-name.recovery.naming-rules",
                    defaultValue: "File names must not contain the : character and be less than 256 characters.",
                    comment: "Recovery guidance describing valid filename rules"
                )
            }
        }
    }
}
