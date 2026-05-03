//
//  Permissions.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabPermissions: Codable {
    var projectAccess: GitLabProjectAccess?
    var groupAccess: GitLabGroupAccess?

    init(_ json: [String: AnyObject]) {
        projectAccess = GitLabProjectAccess(json[String(localized: "gitlab.coding-key.project-access", defaultValue: "project_access", comment: "GitLab API JSON CodingKey - technical constant, should not be localized")] as? [String: AnyObject] ?? [:])
        groupAccess = GitLabGroupAccess(json[String(localized: "gitlab.coding-key.group-access", defaultValue: "group_access", comment: "GitLab API JSON CodingKey - technical constant, should not be localized")] as? [String: AnyObject] ?? [:])
    }
}
