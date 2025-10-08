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
                return String(localized: "file_manager.error.file_not_found", comment: "Error description when a file is not found")
            case .fileNotIndexed:
                return String(localized: "file_manager.error.file_not_indexed", comment: "Error description when a file is not indexed in CodeEdit")
            case .originFileNotFound:
                return String(localized: "file_manager.error.origin_file_not_found", comment: "Error description when the origin file cannot be found")
            case .destinationFileExists:
                return String(localized: "file_manager.error.destination_exists", comment: "Error description when the destination file already exists")
            case .invalidFileName:
                return String(localized: "file_manager.error.invalid_file_name", comment: "Error description for invalid file names")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "file_manager.error.reopen_workspace_suggestion", comment: "Recovery suggestion to reopen workspace for reindexing")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file_manager.error.file_moved_suggestion", comment: "Recovery suggestion when file may have moved during operation")
            case .destinationFileExists:
                return String(localized: "file_manager.error.rename_or_remove_suggestion", comment: "Recovery suggestion to use different name or remove conflicting file")
            case .invalidFileName:
                return String(localized: "file_manager.error.invalid_name_suggestion", comment: "Recovery suggestion for invalid file names with character restrictions")
            }
        }
    }
}
