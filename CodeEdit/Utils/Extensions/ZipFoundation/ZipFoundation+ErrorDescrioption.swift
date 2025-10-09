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
            String(localized: "archive.error.unreadable", comment: "Error message for unreadable archive")
        case .unwritableArchive:
            String(localized: "archive.error.unwritable", comment: "Error message for unwritable archive")
        case .invalidEntryPath:
            String(localized: "archive.error.invalid_entry_path", comment: "Error message for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "archive.error.invalid_compression_method", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "archive.error.invalid_checksum", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "archive.error.operation_cancelled", comment: "Error message for cancelled operation")
        case .invalidBufferSize:
            String(localized: "archive.error.invalid_buffer_size", comment: "Error message for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "archive.error.invalid_entry_size", comment: "Error message for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "archive.error.invalid_file", comment: "Error message for invalid file detected")
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
