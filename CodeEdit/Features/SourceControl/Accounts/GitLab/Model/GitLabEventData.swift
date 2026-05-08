//
//  GitLabEventData.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabEventData: Codable {
    var objectKind: String?
    var eventName: String?
    var before: String?
    var after: String?
    var ref: String?
    var checkoutSha: String?
    var message: String?
    var userID: Int?
    var userName: String?
    var userEmail: String?
    var userAvatar: URL?
    var projectID: Int?
    var project: GitLabProject?
    var commits: [GitLabCommit]?
    var totalCommitsCount: Int?

    enum CodingKeys: String, CodingKey {
        case objectKind = String(localized: "swift.preflight.literal.413984", defaultValue: "object_kind", comment: "")
        case eventName = String(localized: "swift.preflight.literal.413985", defaultValue: "event_name", comment: "")
        case before
        case after
        case ref
        case checkoutSha = String(localized: "swift.preflight.literal.413986", defaultValue: "checkout_sha", comment: "")
        case message
        case userID = String(localized: "swift.preflight.literal.413987", defaultValue: "user_id", comment: "")
        case userName = String(localized: "swift.preflight.literal.413988", defaultValue: "user_name", comment: "")
        case userEmail = String(localized: "swift.preflight.literal.413989", defaultValue: "user_email", comment: "")
        case userAvatar = String(localized: "swift.preflight.literal.413990", defaultValue: "user_avater", comment: "")
        case projectID = String(localized: "swift.preflight.literal.413991", defaultValue: "project_id", comment: "")
        case project
        case commits
        case totalCommitsCount = String(localized: "swift.preflight.literal.413992", defaultValue: "total_commits_count", comment: "")
    }
}
