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
                return String(localized: "file_manager.error.file_not_found", comment: "File not found error")
            case .fileNotIndexed:
                return String(localized: "file_manager.error.file_not_indexed", comment: "File not indexed error")
            case .originFileNotFound:
                return String(localized: "file_manager.error.origin_not_found", comment: "Origin file not found error")
            case .destinationFileExists:
                return String(localized: "file_manager.error.destination_exists", comment: "Destination exists error")
            case .invalidFileName:
                return String(localized: "file_manager.error.invalid_name", comment: "Invalid file name error")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "file_manager.recovery.reopen_workspace", comment: "Reopen workspace suggestion")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file_manager.recovery.file_moved", comment: "File moved suggestion")
            case .destinationFileExists:
                return String(localized: "file_manager.recovery.rename_or_remove", comment: "Rename or remove suggestion")
            case .invalidFileName:
                return String(localized: "file_manager.recovery.invalid_name_rules", comment: "Invalid name rules")
            }
        }
    }
}
