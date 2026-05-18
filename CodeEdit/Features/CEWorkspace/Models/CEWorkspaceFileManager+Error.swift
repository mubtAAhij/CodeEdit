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
                return String(localized: "workspace.file-manager.error.file-not-found", defaultValue: "File not found", comment: "Error when file not found")
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.error.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "Error when file not found in CodeEdit index")
            case .originFileNotFound:
                return String(localized: "workspace.file-manager.error.origin-not-found", defaultValue: "Failed to find origin file", comment: "Error when origin file not found")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.error.destination-exists", defaultValue: "Destination already exists", comment: "Error when destination file already exists")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.error.invalid-filename", defaultValue: "Invalid file name", comment: "Error when file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "workspace.file-manager.recovery.reopen-workspace", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion to reopen workspace")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "workspace.file-manager.recovery.file-moved", defaultValue: "The file may have moved during the operation, try again.", comment: "Recovery suggestion when file may have moved")
            case .destinationFileExists:
                return String(localized: "workspace.file-manager.recovery.rename-or-remove", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion to rename or remove file")
            case .invalidFileName:
                return String(localized: "workspace.file-manager.recovery.valid-filename", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion for valid file name")
            }
        }
    }
}
