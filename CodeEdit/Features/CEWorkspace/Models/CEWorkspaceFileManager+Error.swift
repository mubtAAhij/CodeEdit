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
                return String(localized: "fileManager.fileNotFound", comment: "Error message")
            case .fileNotIndexed:
                return String(localized: "fileManager.fileNotIndexed", comment: "Error message")
            case .originFileNotFound:
                return String(localized: "fileManager.originFileNotFound", comment: "Error message")
            case .destinationFileExists:
                return String(localized: "fileManager.destinationExists", comment: "Error message")
            case .invalidFileName:
                return String(localized: "fileManager.invalidFileName", comment: "Error message")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .fileNotIndexed:
                return String(localized: "fileManager.reopenWorkspace", comment: "Recovery suggestion")
            case .fileNotFound, .originFileNotFound:
                return String(localized: "fileManager.fileMayHaveMoved", comment: "Recovery suggestion")
            case .destinationFileExists:
                return String(localized: "fileManager.useDifferentName", comment: "Recovery suggestion")
            case .invalidFileName:
                return String(localized: "fileManager.invalidFileNameRules", comment: "Recovery suggestion")
            }
        }
    }
}
