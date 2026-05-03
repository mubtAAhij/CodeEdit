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
            String(localized: "zip.error.unreadable_archive", defaultValue: "Unreadable archive.", comment: "Error when archive cannot be read")
        case .unwritableArchive:
            String(localized: "zip.error.unwritable_archive", defaultValue: "Unwritable archive.", comment: "Error when archive cannot be written")
        case .invalidEntryPath:
            String(localized: "zip.error.invalid_entry_path", defaultValue: "Invalid entry path.", comment: "Error when archive entry path is invalid")
        case .invalidCompressionMethod:
            String(localized: "zip.error.invalid_compression_method", defaultValue: "Invalid compression method.", comment: "Error when compression method is invalid")
        case .invalidCRC32:
            String(localized: "zip.error.invalid_checksum", defaultValue: "Invalid checksum.", comment: "Error when checksum is invalid")
        case .cancelledOperation:
            String(localized: "zip.error.operation_cancelled", defaultValue: "Operation cancelled.", comment: "Error when operation is cancelled")
        case .invalidBufferSize:
            String(localized: "zip.error.invalid_buffer_size", defaultValue: "Invalid buffer size.", comment: "Error when buffer size is invalid")
        case .invalidEntrySize:
            String(localized: "zip.error.invalid_entry_size", defaultValue: "Invalid entry size.", comment: "Error when entry size is invalid")
        case .invalidLocalHeaderDataOffset,
                .invalidLocalHeaderSize,
                .invalidCentralDirectoryOffset,
                .invalidCentralDirectorySize,
                .invalidCentralDirectoryEntryCount,
                .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.invalid_file_detected", defaultValue: "Invalid file detected.", comment: "Error when invalid file is detected in archive")
        case .uncontainedSymlink:
            String(localized: "zip.error.uncontained_symlink_detected", defaultValue: "Uncontained symlink detected.", comment: "Error when symlink points outside archive")
        }
    }

    public var failureReason: String? {
        return switch self {
        case .invalidLocalHeaderDataOffset:
            String(localized: "zip.error.invalid_local_header_data_offset", defaultValue: "Invalid local header data offset.", comment: "Failure reason for invalid local header data offset")
        case .invalidLocalHeaderSize:
            String(localized: "zip.error.invalid_local_header_size", defaultValue: "Invalid local header size.", comment: "Failure reason for invalid local header size")
        case .invalidCentralDirectoryOffset:
            String(localized: "zip.error.invalid_central_directory_offset", defaultValue: "Invalid central directory offset.", comment: "Failure reason for invalid central directory offset")
        case .invalidCentralDirectorySize:
            String(localized: "zip.error.invalid_central_directory_size", defaultValue: "Invalid central directory size.", comment: "Failure reason for invalid central directory size")
        case .invalidCentralDirectoryEntryCount:
            String(localized: "zip.error.invalid_central_directory_entry_count", defaultValue: "Invalid central directory entry count.", comment: "Failure reason for invalid central directory entry count")
        case .missingEndOfCentralDirectoryRecord:
            String(localized: "zip.error.missing_end_of_central_directory_record", defaultValue: "Missing end of central directory record.", comment: "Failure reason for missing end of central directory record")
        default:
            nil
        }
    }
}
