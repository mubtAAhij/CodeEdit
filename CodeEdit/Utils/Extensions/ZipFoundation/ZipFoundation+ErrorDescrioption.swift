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
            String(localized: "zipfoundation.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Error description when archive cannot be read")
        case .unwritableArchive:
            String(localized: "zipfoundation.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Error description when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "zipfoundation.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Error description for invalid archive entry path")
        case .invalidCompressionMethod:
            String(localized: "zipfoundation.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Error description for unsupported or invalid compression method")
        case .invalidCRC32:
            String(localized: "zipfoundation.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Error description for checksum validation failure")
        case .cancelledOperation:
            String(localized: "zipfoundation.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Error description when zip operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zipfoundation.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Error description for invalid buffer size during zip processing")
        case .invalidEntrySize:
            String(localized: "zipfoundation.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Error description for invalid archive entry size")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zipfoundation.error.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "Error description when invalid file is detected in archive operation")
        case .uncontainedSymlink:
            String(localized: "zipfoundation.error.uncontained-symlink-detected", defaultValue: "Uncontained symlink detected.", comment: "Error description when symlink points outside extraction root")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zipfoundation.error.invalid-local-header-data-offset", defaultValue: "Invalid local header data offset.", comment: "Error description for invalid local header data offset")
        case .invalidLocalHeaderSize:
            String(localized: "zipfoundation.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Error description for invalid local header size")
        case .invalidCentralDirectoryOffset:
            String(localized: "zipfoundation.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Error description for invalid central directory offset")
        case .invalidCentralDirectorySize:
            String(localized: "zipfoundation.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Error description for invalid central directory size")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zipfoundation.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Error description for invalid central directory entry count")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zipfoundation.error.missing-end-of-central-directory-record", defaultValue: "Missing end of central directory record.", comment: "Error description when end of central directory record is missing")
        default:
            nil
        }
    }
}
