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
                return String(localized: "file-manager.file-not-found", defaultValue: "File not found", comment: "File not found error")
            case .fileNotIndexed:
                return String(localized: "file-manager.file-not-indexed", defaultValue: "File not found in CodeEdit", comment: "File not indexed error")
            case .originFileNotFound:
                return String(localized: "file-manager.origin-file-not-found", defaultValue: "Failed to find origin file", comment: "Origin file not found error")
            case .destinationFileExists:
                return String(localized: "file-manager.destination-exists", defaultValue: "Destination already exists", comment: "Destination already exists error")
            case .invalidFileName:
                return String(localized: "file-manager.invalid-file-name", defaultValue: "Invalid file name", comment: "Invalid file name error")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "file-manager.reopen-workspace", defaultValue: "Reopen the workspace to reindex the file system.", comment: "Reopen workspace suggestion")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "file-manager.file-moved", defaultValue: "The file may have moved during the operation, try again.", comment: "File moved suggestion")
            case .destinationFileExists:
                return String(localized: "file-manager.use-different-name", defaultValue: "Use a different file name or remove the conflicting file.", comment: "Use different name suggestion")
            case .invalidFileName:
                return String(localized: "file-manager.invalid-name-rules", defaultValue: "File names must not contain the : character and be less than 256 characters.", comment: "Invalid file name rules")
            }
        }
    }
}
