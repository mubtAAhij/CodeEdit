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
                return String(localized: "file_manager.error.file_not_found", comment: "Error message when file is not found")
            case .fileNotIndexed:
                return String(localized: "file_manager.error.file_not_indexed", comment: "Error message when file is not indexed in CodeEdit")
            case .originFileNotFound:
                return String(localized: "file_manager.error.origin_not_found", comment: "Error message when origin file cannot be found")
            case .destinationFileExists:
                return String(localized: "file_manager.error.destination_exists", comment: "Error message when destination file already exists")
            case .invalidFileName:
                return String(localized: "file_manager.error.invalid_filename", comment: "Error message for invalid file name")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "file_manager.error.reopen_workspace", comment: "Recovery suggestion to reopen workspace")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file_manager.error.file_moved", comment: "Recovery suggestion when file may have moved")
            case .destinationFileExists:
                return String(localized: "file_manager.error.resolve_conflict", comment: "Recovery suggestion to resolve file conflict")
            case .invalidFileName:
                return String(localized: "file_manager.error.filename_rules", comment: "Error message explaining filename rules")
            }
        }
    }
}
