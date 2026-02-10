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
            String(localized: "zip.error.unreadable-archive", defaultValue: "Unreadable archive.", comment: "Unreadable archive error")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable-archive", defaultValue: "Unwritable archive.", comment: "Unwritable archive error")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid-entry-path", defaultValue: "Invalid entry path.", comment: "Invalid entry path error")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid-compression-method", defaultValue: "Invalid compression method.", comment: "Invalid compression method error")
        case .invalidCRC32:
            String(localized: "zip.error.invalid-checksum", defaultValue: "Invalid checksum.", comment: "Invalid checksum error")
        case .cancelledOperation:
            String(localized: "zip.error.operation-cancelled", defaultValue: "Operation cancelled.", comment: "Operation cancelled error")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid-buffer-size", defaultValue: "Invalid buffer size.", comment: "Invalid buffer size error")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid-entry-size", defaultValue: "Invalid entry size.", comment: "Invalid entry size error")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid-file-detected", defaultValue: "Invalid file detected.", comment: "Invalid file detected error")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained-symlink", defaultValue: "Uncontained symlink detected.", comment: "Uncontained symlink error")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.error.invalid-local-header-data-offset", defaultValue: "Invalid local header data offset.", comment: "Invalid local header data offset error")
        case .invalidLocalHeaderSize:
            String(localized: "zip.error.invalid-local-header-size", defaultValue: "Invalid local header size.", comment: "Invalid local header size error")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.error.invalid-central-directory-offset", defaultValue: "Invalid central directory offset.", comment: "Invalid central directory offset error")
        case .invalidCentralDirectorySize:
            String(localized: "zip.error.invalid-central-directory-size", defaultValue: "Invalid central directory size.", comment: "Invalid central directory size error")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.error.invalid-central-directory-entry-count", defaultValue: "Invalid central directory entry count.", comment: "Invalid central directory entry count error")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.missing-end-of-central-directory-record", defaultValue: "Missing end of central directory record.", comment: "Missing end of central directory record error")
        default:
            nil
        }
    }
}
