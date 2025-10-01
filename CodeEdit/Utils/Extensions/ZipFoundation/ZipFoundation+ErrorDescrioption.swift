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
            String(localized: "zipfoundation.error.unreadable_archive", comment: "Error message for unreadable archive")
        case .unwritableArchive:
            String(localized: "zipfoundation.error.unwritable_archive", comment: "Error message for unwritable archive")
        case .invalidEntryPath:
            String(localized: "zipfoundation.error.invalid_entry_path", comment: "Error message for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "zipfoundation.error.invalid_compression_method", comment: "Error message for invalid compression method in ZIP files")
        case .invalidCRC32:
            String(localized: "zipfoundation.error.invalid_checksum", comment: "Error message for invalid checksum in ZIP files")
        case .cancelledOperation:
            String(localized: "zip.error.operation_cancelled", comment: "Error message when zip operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid_buffer_size", comment: "Error message for invalid buffer size in zip operations")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid_entry_size", comment: "Error message for invalid entry size in zip operations")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid_file_detected", comment: "Error message when invalid file is detected in zip operations")
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
