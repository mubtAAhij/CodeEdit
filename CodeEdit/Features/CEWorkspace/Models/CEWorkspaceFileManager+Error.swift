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
                return String(localized: "file_not_found", comment: "Error when file cannot be found")
            case .fileNotIndexed:
                return String(localized: "file_not_found_in_codeedit", comment: "Error when file is not indexed in CodeEdit")
            case .originFileNotFound:
                return String(localized: "failed_to_find_origin_file", comment: "Error when origin file cannot be found")
            case .destinationFileExists:
                return String(localized: "destination_already_exists", comment: "Error when destination file already exists")
            case .invalidFileName:
                return String(localized: "invalid_file_name", comment: "Error when file name is invalid")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "reopen_workspace_to_reindex", comment: "Recovery suggestion for reindexing file system")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file_may_have_moved_try_again", comment: "Recovery suggestion when file may have moved")
            case .destinationFileExists:
                return String(localized: "use_different_filename_or_remove_conflict", comment: "Recovery suggestion for file name conflicts")
            case .invalidFileName:
                return String(localized: "filename_requirements", comment: "Requirements for valid file names")
            }
        }
    }
}
