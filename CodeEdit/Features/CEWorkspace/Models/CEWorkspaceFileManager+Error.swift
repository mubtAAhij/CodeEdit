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
                return String(localized: "workspace.file-manager.error.file-not-found.title", defaultValue: "File not found", comment: "Title for error when a file cannot be found.")
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.error.file-not-found-in-codeedit.title", defaultValue: "File not found in CodeEdit", comment: "Title for error when file is missing from CodeEdit index.")
            case .originFileNotFound:
                return String(localized: "workspace.file-manager.error.failed-to-find-origin-file.title", defaultValue: "Failed to find origin file", comment: "Title for error when original file cannot be located.")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.error.destination-already-exists.title", defaultValue: "Destination already exists", comment: "Title for error when destination path is already used.")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.error.invalid-file-name.title", defaultValue: "Invalid file name", comment: "Title for error when provided file name is invalid.")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.error.file-not-found.recovery", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion when file is not found.")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "workspace.file-manager.error.origin-file-moved.recovery", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion when origin file moved during operation.")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.error.destination-exists.recovery", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion when destination already exists.")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.error.invalid-file-name.recovery", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion explaining file name constraints.")
            }
        }
    }
}
