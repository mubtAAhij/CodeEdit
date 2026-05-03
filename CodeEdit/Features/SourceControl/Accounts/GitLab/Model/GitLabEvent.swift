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
        case projectID = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case actionName = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case targetID = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case targetType = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case authorID = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case data
        case targetTitle = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case author
        case authorUsername = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case createdAt = String(localized: "SKIPPED", defaultValue: "SKIPPED", comment: "SKIPPED - CodingKeys enum case raw value (JSON API field name)")
        case note
    }
}
