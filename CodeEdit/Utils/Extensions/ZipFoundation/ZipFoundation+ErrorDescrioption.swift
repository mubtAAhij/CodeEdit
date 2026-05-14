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
            String(localized: "zip.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error message when archive file cannot be read")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error message when archive file cannot be written")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error message when archive entry has invalid path")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error message when archive uses unsupported compression")
        case .invalidCRC32:
            String(localized: "zip.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error message when archive checksum validation fails")
        case .cancelledOperation:
            String(localized: "zip.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error message when archive operation was cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error message when archive buffer size is invalid")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error message when archive entry size is invalid")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "Error message when archive file structure is corrupted")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained-symlink", defaultValue: "Uncontained symlink detected.", comment: "Error message when archive contains symlink pointing outside archive")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.error.invalid-local-header-offset", defaultValue: "Invalid local header data offset.", comment: "Failure reason for invalid local header data offset in archive")
        case .invalidLocalHeaderSize:
            String(localized: "zip.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Failure reason for invalid local header size in archive")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Failure reason for invalid central directory offset in archive")
        case .invalidCentralDirectorySize:
            String(localized: "zip.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Failure reason for invalid central directory size in archive")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Failure reason for invalid central directory entry count in archive")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.missing-end-of-central-directory", defaultValue: "Missing end of central directory record.", comment: "Failure reason for missing end of central directory record in archive")
        default:
            nil
        }
    }
}
