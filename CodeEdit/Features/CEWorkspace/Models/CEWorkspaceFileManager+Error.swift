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
                return String(localized: "file_not_found", comment: "Error message when a file cannot be found")
            case .fileNotIndexed:
                return String(localized: "file_not_found_in_codeedit", comment: "Error message when a file is not found in CodeEdit's index")
            case .originFileNotFound:
                return String(localized: "failed_to_find_origin_file", comment: "Error message when the source file for an operation cannot be found")
            case .destinationFileExists:
                return String(localized: "destination_already_exists", comment: "Error message when trying to create a file/folder that already exists")
            case .invalidFileName:
                return String(localized: "invalid_file_name", comment: "Error message when a file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "reopen_workspace_to_reindex", comment: "Recovery suggestion for reindexing the file system")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file_may_have_moved_try_again", comment: "Recovery suggestion when a file operation fails due to file movement")
            case .destinationFileExists:
                return String(localized: "use_different_name_or_remove_conflict", comment: "Recovery suggestion for file name conflicts")
            case .invalidFileName:
                return String(localized: "file_name_requirements", comment: "File naming requirements explanation")
            }
        }
    }
}
