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
            String(localized: "zip.error.unreadable.archive", defaultValue: "Unreadable archive.", comment: "Error message when archive cannot be read")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable.archive", defaultValue: "Unwritable archive.", comment: "Error message when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid.entry.path", defaultValue: "Invalid entry path.", comment: "Error message for invalid archive entry path")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid.compression.method", defaultValue: "Invalid compression method.", comment: "Error message for unsupported compression method")
        case .invalidCRC32:
            String(localized: "zip.error.invalid.checksum", defaultValue: "Invalid checksum.", comment: "Error message when file checksum validation fails")
        case .cancelledOperation:
            String(localized: "zip.error.operation.cancelled", defaultValue: "Operation cancelled.", comment: "Error message when archive operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid.buffer.size", defaultValue: "Invalid buffer size.", comment: "Error message for invalid buffer size during archive operation")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid.entry.size", defaultValue: "Invalid entry size.", comment: "Error message when archive entry has invalid size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid.file.detected", defaultValue: "Invalid file detected.", comment: "Generic error message for corrupted archive file")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained.symlink", defaultValue: "Uncontained symlink detected.", comment: "Error message when archive contains symlink pointing outside archive")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.failure.invalid.local.header.offset", defaultValue: "Invalid local header data offset.", comment: "Detailed failure reason for invalid local header offset in archive")
        case .invalidLocalHeaderSize:
            String(localized: "zip.failure.invalid.local.header.size", defaultValue: "Invalid local header size.", comment: "Detailed failure reason for invalid local header size in archive")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.failure.invalid.central.directory.offset", defaultValue: "Invalid central directory offset.", comment: "Detailed failure reason for invalid central directory offset in archive")
        case .invalidCentralDirectorySize:
            String(localized: "zip.failure.invalid.central.directory.size", defaultValue: "Invalid central directory size.", comment: "Detailed failure reason for invalid central directory size in archive")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.failure.invalid.central.directory.entry.count", defaultValue: "Invalid central directory entry count.", comment: "Detailed failure reason for invalid entry count in central directory")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.failure.missing.end.of.central.directory", defaultValue: "Missing end of central directory record.", comment: "Detailed failure reason for missing end of central directory record")
        default:
            nil
        }
    }
}
