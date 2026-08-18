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
                    localized: "workspace.file-manager.error.file-not-found.title",
                    defaultValue: "File not found",
                    comment: "Error title when a file cannot be found"
                )
            case .fileNotIndexed:
                return String(
                    localized: "workspace.file-manager.error.file-not-found-in-codeedit.title",
                    defaultValue: "File not found in CodeEdit",
                    comment: "Error title when file is not found in CodeEdit index"
                )
            case .originFileNotFound:
                return String(
                    localized: "workspace.file-manager.error.origin-file-not-found.title",
                    defaultValue: "Failed to find origin file",
                    comment: "Error title when source file cannot be found during file operation"
                )
            case .destinationFileExists:
                return String(
                    localized: "workspace.file-manager.error.destination-exists.title",
                    defaultValue: "Destination already exists",
                    comment: "Error title when destination path already exists"
                )
            case .invalidFileName:
                return String(
                    localized: "workspace.file-manager.error.invalid-file-name.title",
                    defaultValue: "Invalid file name",
                    comment: "Error title when entered file name is invalid"
                )
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(
                    localized: "workspace.file-manager.error.file-not-found.recovery-suggestion",
                    defaultValue: "Reopen the workspace to reindex the file system.",
                    comment: "Recovery suggestion for file not found errors"
                )
            case .fileNotFound, .originFileNotFound:
                return String(
                    localized: "workspace.file-manager.error.origin-file-not-found.recovery-suggestion",
                    defaultValue: "The file may have moved during the operation, try again.",
                    comment: "Recovery suggestion when source file moved during operation"
                )
            case .destinationFileExists:
                return String(
                    localized: "workspace.file-manager.error.destination-exists.recovery-suggestion",
                    defaultValue: "Use a different file name or remove the conflicting file.",
                    comment: "Recovery suggestion when destination already exists"
                )
            case .invalidFileName:
                return String(
                    localized: "workspace.file-manager.error.invalid-file-name.recovery-suggestion",
                    defaultValue: "File names must not contain the : character and be less than 256 characters.",
                    comment: "Recovery suggestion explaining valid file name requirements"
                )
            }
        }
    }
}
