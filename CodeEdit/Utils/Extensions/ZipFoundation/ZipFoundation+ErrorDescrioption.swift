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
            String(localized: "zip.error.unreadable", defaultValue: "Unreadable archive.", comment: "Error message when archive cannot be read")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable", defaultValue: "Unwritable archive.", comment: "Error message when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid-path", defaultValue: "Invalid entry path.", comment: "Error message for invalid entry path in archive")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid-compression", defaultValue: "Invalid compression method.", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "zip.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "zip.error.cancelled", defaultValue: "Operation cancelled.", comment: "Error message when operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid-buffer", defaultValue: "Invalid buffer size.", comment: "Error message for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error message for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid-file", defaultValue: "Invalid file detected.", comment: "Error message when invalid file is detected")
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
