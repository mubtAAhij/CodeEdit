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
            String(localized: "archive.error.unreadable", defaultValue: "Unreadable archive.", comment: "Error when archive cannot be read")
        case .unwritableArchive:
            String(localized: "archive.error.unwritable", defaultValue: "Unwritable archive.", comment: "Error when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "archive.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error for invalid entry path in archive")
        case .invalidCompressionMethod:
            String(localized: "archive.error.invalid-compression", defaultValue: "Invalid compression method.", comment: "Error for invalid compression method")
        case .invalidCRC32:
            String(localized: "archive.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error for invalid checksum")
        case .cancelledOperation:
            String(localized: "archive.error.cancelled", defaultValue: "Operation cancelled.", comment: "Error when operation is cancelled")
        case .invalidBufferSize:
            String(localized: "archive.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "archive.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "archive.error.invalid-file", defaultValue: "Invalid file detected.", comment: "Error for invalid file structure")
        case .uncontainedSymlink:
            "Uncontained symlink detected."
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            "Invalid local header data offset."
        case .invalidLocalHeaderSize:
            "Invalid local header size."
        case .invalidCentralDirectoryOffset:
            "Invalid central directory offset."
        case .invalidCentralDirectorySize:
            "Invalid central directory size."
        case .invalidCentralDirectoryEntryCount:
            "Invalid central directory entry count."
        case .missingEndOfCentralDirectoryRecord:
            "Missing end of central directory record."
        default:
            nil
        }
    }
}
