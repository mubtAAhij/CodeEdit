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
                return String(localized: "File not found", comment: "Error description for file not found")
            case .fileNotIndexed:
                return String(localized: "File not found in CodeEdit", comment: "Error description for file not indexed")
            case .originFileNotFound:
                return String(localized: "Failed to find origin file", comment: "Error description for origin file not found")
            case .destinationFileExists:
                return String(localized: "Destination already exists", comment: "Error description for destination file exists")
            case .invalidFileName:
                return String(localized: "Invalid file name", comment: "Error description for invalid file name")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "Reopen the workspace to reindex the file system.", comment: "Recovery suggestion for file not indexed")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "The file may have moved during the operation, try again.", comment: "Recovery suggestion for file not found")
            case .destinationFileExists:
                return String(localized: "Use a different file name or remove the conflicting file.", comment: "Recovery suggestion for destination file exists")
            case .invalidFileName:
                return String(localized: "File names must not contain the : character and be less than 256 characters.", comment: "Recovery suggestion for invalid file name")
            }
        }
    }
}
