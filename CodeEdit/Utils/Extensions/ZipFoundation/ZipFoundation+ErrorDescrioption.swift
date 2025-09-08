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
            "Unreadable archive."
        case .unwritableArchive:
            "Unwritable archive."
        case .invalidEntryPath:
            "Invalid entry path."
        case .invalidCompressionMethod:
            String(localized: "invalid_compression_method", comment: "Error message for invalid compression method")
        case .invalidCRC32:
            String(localized: "invalid_checksum", comment: "Error message for invalid checksum")
        case .cancelledOperation:
            String(localized: "operation_cancelled", comment: "Error message for cancelled operation")
        case .invalidBufferSize:
            "Invalid buffer size."
        case .invalidEntrySize:
            "Invalid entry size."
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
