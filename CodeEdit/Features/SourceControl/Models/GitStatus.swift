//
//  GitType.swift
//  
//
//  Created by Nanashi Li on 2022/05/20.
//

import Foundation

enum GitStatus: String, Codable {
    case none = "."
    case modified = "M"
    case untracked = "?"
    case fileTypeChange = "T"
    case added = "A"
    case deleted = "D"
    case renamed = "R"
    case copied = "C"
    case unmerged = "U"

    var description: String {
        switch self {
        case .modified: return String(localized: "git.status.code.modified", defaultValue: "M", comment: "Git status code for modified files")
        case .untracked: return String(localized: "git.status.code.untracked", defaultValue: "U", comment: "Git status code for untracked files")
        case .fileTypeChange: return String(localized: "git.status.code.type.change", defaultValue: "T", comment: "Git status code for file type changes")
        case .added: return String(localized: "git.status.code.added", defaultValue: "A", comment: "Git status code for added files")
        case .deleted: return String(localized: "git.status.code.deleted", defaultValue: "D", comment: "Git status code for deleted files")
        case .renamed: return String(localized: "git.status.code.renamed", defaultValue: "R", comment: "Git status code for renamed files")
        case .copied: return String(localized: "git.status.code.copied", defaultValue: "C", comment: "Git status code for copied files")
        case .unmerged: return String(localized: "git.status.code.unmerged", defaultValue: "U", comment: "Git status code for unmerged files")
        case .none: return ""
        }
    }
}
