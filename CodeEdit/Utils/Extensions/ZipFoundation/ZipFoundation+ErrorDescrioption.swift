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
            String(localized: "unreadable_archive", comment: "Error message for unreadable archive")
        case .unwritableArchive:
            String(localized: "unwritable_archive", comment: "Error message for unwritable archive")
        case .invalidEntryPath:
            String(localized: "invalid_entry_path", comment: "Error message for invalid entry path")
        case .invalidCompressionMethod:
            String(localized: "invalid_compression_method", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "invalid_checksum", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "zip_operation_cancelled", comment: "Error message when zip operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip_invalid_buffer_size", comment: "Error message for invalid buffer size")
        case .invalidEntrySize:
            String(localized: "zip_invalid_entry_size", comment: "Error message for invalid entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            "Invalid file detected."
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
