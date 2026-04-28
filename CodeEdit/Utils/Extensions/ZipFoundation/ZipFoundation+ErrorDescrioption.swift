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
            String(localized: "zip.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error when archive is unreadable")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error when archive is unwritable")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error when entry path is invalid")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error when compression method is invalid")
        case .invalidCRC32:
            String(localized: "zip.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error when checksum is invalid")
        case .cancelledOperation:
            String(localized: "zip.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error when operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error when buffer size is invalid")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error when entry size is invalid")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "Error when invalid file is detected")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained-symlink", defaultValue: "Uncontained symlink detected.", comment: "Error when uncontained symlink is detected")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.error.invalid-local-header-data-offset", defaultValue: "Invalid local header data offset.", comment: "Error when local header data offset is invalid")
        case .invalidLocalHeaderSize:
            String(localized: "zip.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Error when local header size is invalid")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Error when central directory offset is invalid")
        case .invalidCentralDirectorySize:
            String(localized: "zip.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Error when central directory size is invalid")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Error when central directory entry count is invalid")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.missing-end-of-central-directory-record", defaultValue: "Missing end of central directory record.", comment: "Error when end of central directory record is missing")
        default:
            nil
        }
    }
}
