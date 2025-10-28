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
            String(localized: "archive.error.unreadable", comment: "Unreadable archive error")
        case .unwritableArchive:
            String(localized: "archive.error.unwritable", comment: "Unwritable archive error")
        case .invalidEntryPath:
            String(localized: "archive.error.invalid_path", comment: "Invalid entry path error")
        case .invalidCompressionMethod:
            String(localized: "archive.error.invalid_compression", comment: "Invalid compression method error")
        case .invalidCRC32:
            String(localized: "archive.error.invalid_checksum", comment: "Invalid checksum error")
        case .cancelledOperation:
            String(localized: "archive.error.cancelled", comment: "Operation cancelled error")
        case .invalidBufferSize:
            String(localized: "archive.error.invalid_buffer", comment: "Invalid buffer size error")
        case .invalidEntrySize:
            String(localized: "archive.error.invalid_entry_size", comment: "Invalid entry size error")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "archive.error.invalid_file", comment: "Invalid file error")
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
