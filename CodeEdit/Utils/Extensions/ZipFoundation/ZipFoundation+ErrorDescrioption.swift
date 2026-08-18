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
            String(localized: "zip-foundation.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error description when archive cannot be read")
        case .unwritableArchive:
            String(localized: "zip-foundation.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error description when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "zip-foundation.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error description for invalid entry path in archive")
        case .invalidCompressionMethod:
            String(localized: "zip-foundation.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error description for unsupported compression method")
        case .invalidCRC32:
            String(localized: "zip-foundation.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error description for checksum mismatch")
        case .cancelledOperation:
            String(localized: "zip-foundation.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error description when zip operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip-foundation.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error description for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "zip-foundation.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error description for invalid archive entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip-foundation.error.file-system.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "File system error description for invalid file")
        case .uncontainedSymlink:
            String(localized: "zip-foundation.error.file-system.uncontained-symlink-detected", defaultValue: "Uncontained symlink detected.", comment: "File system error description for unsafe symlink")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip-foundation.error.archive.invalid-local-header-data-offset", defaultValue: "Invalid local header data offset.", comment: "Archive structure error for invalid local header data offset")
        case .invalidLocalHeaderSize:
            String(localized: "zip-foundation.error.archive.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Archive structure error for invalid local header size")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip-foundation.error.archive.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Archive structure error for invalid central directory offset")
        case .invalidCentralDirectorySize:
            String(localized: "zip-foundation.error.archive.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Archive structure error for invalid central directory size")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip-foundation.error.archive.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Archive structure error for invalid central directory entry count")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip-foundation.error.archive.missing-end-of-central-directory-record", defaultValue: "Missing end of central directory record.", comment: "Archive structure error for missing end of central directory record")
        default:
            nil
        }
    }
}
