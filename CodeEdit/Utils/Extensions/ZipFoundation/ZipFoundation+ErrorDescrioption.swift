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
            String(localized: "error.unreadable_archive", comment: "Error message for unreadable archive")
        case .unwritableArchive:
            String(localized: "error.unwritable_archive", comment: "Error message for unwritable archive")
        case .invalidEntryPath:
            String(localized: "error.invalid_entry_path", comment: "Error message for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "error.invalid_compression_method", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "error.invalid_checksum", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "zip_foundation.error.operation_cancelled", comment: "Zip operation was cancelled by user")
        case .invalidBufferSize:
            String(localized: "zip_foundation.error.invalid_buffer_size", comment: "Zip buffer size is invalid")
        case .invalidEntrySize:
            String(localized: "zip_foundation.error.invalid_entry_size", comment: "Zip entry size is invalid")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip_foundation.error.invalid_file_detected", comment: "Invalid file found in zip archive")
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
