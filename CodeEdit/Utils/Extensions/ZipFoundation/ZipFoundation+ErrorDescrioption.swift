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
            String(
                localized: "zip-foundation.error.unreadable-archive",
                defaultValue: "Unreadable archive.",
                comment: "Zip archive error description for unreadable archive."
            )
        case .unwritableArchive:
            String(
                localized: "zip-foundation.error.unwritable-archive",
                defaultValue: "Unwritable archive.",
                comment: "Zip archive error description for unwritable archive."
            )
        case .invalidEntryPath:
            String(
                localized: "zip-foundation.error.invalid-entry-path",
                defaultValue: "Invalid entry path.",
                comment: "Zip archive error description for invalid entry path."
            )
        case .invalidCompressionMethod:
            String(
                localized: "zip-foundation.error.invalid-compression-method",
                defaultValue: "Invalid compression method.",
                comment: "Zip archive error description for invalid compression method."
            )
        case .invalidCRC32:
            String(
                localized: "zip-foundation.error.invalid-checksum",
                defaultValue: "Invalid checksum.",
                comment: "Zip archive error description for invalid checksum."
            )
        case .cancelledOperation:
            String(
                localized: "zip-foundation.error.operation-cancelled",
                defaultValue: "Operation cancelled.",
                comment: "Zip archive error description for cancelled operation."
            )
        case .invalidBufferSize:
            String(
                localized: "zip-foundation.error.invalid-buffer-size",
                defaultValue: "Invalid buffer size.",
                comment: "Zip archive error description for invalid buffer size."
            )
        case .invalidEntrySize:
            String(
                localized: "zip-foundation.error.invalid-entry-size",
                defaultValue: "Invalid entry size.",
                comment: "Zip archive error description for invalid entry size."
            )
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(
                localized: "zip-foundation.error.invalid-file-detected",
                defaultValue: "Invalid file detected.",
                comment: "Zip archive error description for invalid file detection."
            )
        case .uncontainedSymlink:
            String(
                localized: "zip-foundation.error.uncontained-symlink-detected",
                defaultValue: "Uncontained symlink detected.",
                comment: "Zip archive error description for uncontained symlink detection."
            )
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(
                localized: "zip-foundation.error.invalid-local-header-data-offset",
                defaultValue: "Invalid local header data offset.",
                comment: "Zip archive error description for invalid local header data offset."
            )
        case .invalidLocalHeaderSize:
            String(
                localized: "zip-foundation.error.invalid-local-header-size",
                defaultValue: "Invalid local header size.",
                comment: "Zip archive error description for invalid local header size."
            )
        case .invalidCentralDirectoryOffset:
            String(
                localized: "zip-foundation.error.invalid-central-directory-offset",
                defaultValue: "Invalid central directory offset.",
                comment: "Zip archive error description for invalid central directory offset."
            )
        case .invalidCentralDirectorySize:
            String(
                localized: "zip-foundation.error.invalid-central-directory-size",
                defaultValue: "Invalid central directory size.",
                comment: "Zip archive error description for invalid central directory size."
            )
        case .invalidCentralDirectoryEntryCount:
            String(
                localized: "zip-foundation.error.invalid-central-directory-entry-count",
                defaultValue: "Invalid central directory entry count.",
                comment: "Zip archive error description for invalid central directory entry count."
            )
        case .missingEndOfCentralDirectoryRecord:
            String(
                localized: "zip-foundation.error.missing-end-of-central-directory-record",
                defaultValue: "Missing end of central directory record.",
                comment: "Zip archive error description for missing end of central directory record."
            )
        default:
            nil
        }
    }
}
