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
            String(localized: "zip-foundation.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error description for unreadable archive")
        case .unwritableArchive:
            String(localized: "zip-foundation.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error description for unwritable archive")
        case .invalidEntryPath:
            String(localized: "zip-foundation.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error description for invalid zip entry path")
        case .invalidCompressionMethod:
            String(localized: "zip-foundation.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error description for invalid compression method")
        case .invalidCRC32:
            String(localized: "zip-foundation.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error description for checksum validation failure")
        case .cancelledOperation:
            String(localized: "zip-foundation.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error description for cancelled archive operation")
        case .invalidBufferSize:
            String(localized: "zip-foundation.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error description for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "zip-foundation.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error description for invalid zip entry size")
        case .invalidLocalHeaderDataOffset,
             .invalidLocalHeaderSize,
             .invalidCentralDirectoryOffset,
             .invalidCentralDirectorySize,
             .invalidCentralDirectoryEntryCount,
             .missingEndOfCentralDirectoryRecord:
            String(localized: "zip-foundation.archive-utility.error.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "Archive utility error when an invalid file is detected")
        case .uncontainedSymlink:
            String(localized: "zip-foundation.archive-utility.error.uncontained-symlink-detected", defaultValue: "Uncontained symlink detected.", comment: "Archive utility error when an unsafe symlink is detected")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip-foundation.archive-utility.error.invalid-local-header-data-offset", defaultValue: "Invalid local header data offset.", comment: "Archive utility error when local header data offset is invalid")
        case .invalidLocalHeaderSize:
            String(localized: "zip-foundation.archive-utility.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Archive utility error when local header size is invalid")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip-foundation.archive-utility.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Archive utility error when central directory offset is invalid")
        case .invalidCentralDirectorySize:
            String(localized: "zip-foundation.archive-utility.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Archive utility error when central directory size is invalid")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip-foundation.archive-utility.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Archive utility error when central directory entry count is invalid")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip-foundation.archive-utility.error.missing-end-of-central-directory-record", defaultValue: "Missing end of central directory record.", comment: "Archive utility error when end of central directory record is missing")
        default:
            nil
        }
    }
}
