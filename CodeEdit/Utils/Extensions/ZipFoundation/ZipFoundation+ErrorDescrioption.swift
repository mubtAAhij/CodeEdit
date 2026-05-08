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
            String(localized: "zip.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error message for unreadable archive")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error message for unwritable archive")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error message for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "zip.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "zip.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error message for cancelled operation")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error message for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error message for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid-file", defaultValue: "Invalid file detected.", comment: "Error message for invalid file")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained-symlink", defaultValue: "Uncontained symlink detected.", comment: "Error message for uncontained symlink")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.error.invalid-local-header-offset", defaultValue: "Invalid local header data offset.", comment: "Error message for invalid local header data offset")
        case .invalidLocalHeaderSize:
            String(localized: "zip.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Error message for invalid local header size")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Error message for invalid central directory offset")
        case .invalidCentralDirectorySize:
            String(localized: "zip.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Error message for invalid central directory size")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Error message for invalid central directory entry count")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.missing-end-of-central-directory", defaultValue: "Missing end of central directory record.", comment: "Error message for missing end of central directory record")
        default:
            nil
        }
    }
}
