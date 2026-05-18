//
//  GitLabEvent.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabEvent: Codable {
    var title: String?
    var projectID: Int?
    var actionName: String?
    var targetID: Int?
    var targetType: String?
    var authorID: Int?
    var data: GitLabEventData?
    var targetTitle: String?
    var author: GitLabUser?
    var authorUsername: String?
    var createdAt: Date?
    var note: GitLabEventNote?

    enum CodingKeys: String, CodingKey {
        case title
        case projectID = String(localized: "swift.preflight.literal.437709", defaultValue: "project_id", comment: "")
        case actionName = String(localized: "swift.preflight.literal.437710", defaultValue: "action_name", comment: "")
        case targetID = String(localized: "swift.preflight.literal.437711", defaultValue: "target_id", comment: "")
        case targetType = String(localized: "swift.preflight.literal.437712", defaultValue: "target_type", comment: "")
        case authorID = String(localized: "swift.preflight.literal.437713", defaultValue: "author_id", comment: "")
        case data
        case targetTitle = String(localized: "swift.preflight.literal.437714", defaultValue: "target_title", comment: "")
        case author
        case authorUsername = String(localized: "swift.preflight.literal.437715", defaultValue: "author_username", comment: "")
        case createdAt = String(localized: "swift.preflight.literal.437716", defaultValue: "created_at", comment: "")
        case note
    }
}
