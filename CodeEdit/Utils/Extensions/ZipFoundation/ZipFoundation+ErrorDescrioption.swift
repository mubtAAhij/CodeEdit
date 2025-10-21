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
            String(localized: "zip.error.unreadableArchive", comment: "Error message")
        case .unwritableArchive:
            String(localized: "zip.error.unwritableArchive", comment: "Error message")
        case .invalidEntryPath:
            String(localized: "zip.error.invalidEntryPath", comment: "Error message")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalidCompressionMethod", comment: "Error message")
        case .invalidCRC32:
            String(localized: "zip.error.invalidChecksum", comment: "Error message")
        case .cancelledOperation:
            String(localized: "zip.error.operationCancelled", comment: "Error message")
        case .invalidBufferSize:
            String(localized: "zip.error.invalidBufferSize", comment: "Error message")
        case .invalidEntrySize:
            String(localized: "zip.error.invalidEntrySize", comment: "Error message")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalidFile", comment: "Error message")
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
