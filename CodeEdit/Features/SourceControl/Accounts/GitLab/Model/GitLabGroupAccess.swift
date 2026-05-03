//
//  GitLabGroupAccess.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabGroupAccess: Codable {
    var accessLevel: Int?
    var notificationLevel: Int?

    init(_ json: [String: AnyObject]) {
        accessLevel = json[String(localized: "gitlab.coding-key.access-level", defaultValue: "access_level", comment: "GitLab API JSON CodingKey - technical constant, should not be localized")] as? Int
        notificationLevel = json[String(localized: "gitlab.coding-key.notification-level", defaultValue: "notification_level", comment: "GitLab API JSON CodingKey - technical constant, should not be localized")] as? Int
    }
}
