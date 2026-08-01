//
//  ZipFoundation+ErrorDescrioption.swift
//  CodeEdit
//
//  Created by Khan Winter on 8/14/25.
//

import Foundation
import ZIPFoundation

extension Archive.ArchiveError: @retroactive LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unreadableArchive:
            String(localized: "archive-error.unreadable", defaultValue: "Unreadable archive.", comment: "Error description for unreadable archive")
        case .unwritableArchive:
            String(localized: "archive-error.unwritable", defaultValue: "Unwritable archive.", comment: "Error description for unwritable archive")
        case .invalidEntryPath:
            String(localized: "archive-error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error description for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "archive-error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error description for invalid compression method")
        case .invalidCRC32:
            String(localized: "archive-error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error description for invalid checksum")
        case .cancelledOperation:
            String(localized: "archive-error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error description for cancelled operation")
        case .invalidBufferSize:
            String(localized: "archive-error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error description for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "archive-error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error description for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "archive-error.invalid-file", defaultValue: "Invalid file detected.", comment: "Error description for invalid file detected")
        case .uncontainedSymlink:
            String(localized: "archive-error.uncontained-symlink", defaultValue: "Uncontained symlink detected.", comment: "Error description for uncontained symlink")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "archive-error.invalid-local-header-offset", defaultValue: "Invalid local header data offset.", comment: "Failure reason for invalid local header data offset")
        case .invalidLocalHeaderSize:
            String(localized: "archive-error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Failure reason for invalid local header size")
        case .invalidCentralDirectoryOffset:
            String(localized: "archive-error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Failure reason for invalid central directory offset")
        case .invalidCentralDirectorySize:
            String(localized: "archive-error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Failure reason for invalid central directory size")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "archive-error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Failure reason for invalid central directory entry count")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "archive-error.missing-end-of-central-directory", defaultValue: "Missing end of central directory record.", comment: "Failure reason for missing end of central directory record")
        default:
            nil
        }
    }
}
