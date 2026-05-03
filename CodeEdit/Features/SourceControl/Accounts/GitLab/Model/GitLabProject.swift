//
//  GitLabProject.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitLabVisibilityLevel: Int {
    case `private` = 0
    case `internal` = 10
    case `public` = 20
}

class GitLabProject: Codable {
    let id: Int
    let owner: GitLabUser
    var name: String?
    var nameWithNamespace: String?
    var isPrivate: Bool?
    var projectDescription: String?
    var sshURL: URL?
    var cloneURL: URL?
    var webURL: URL?
    var path: String?
    var pathWithNamespace: String?
    var containerRegistryEnabled: Bool?
    var defaultBranch: String?
    var tagList: [String]?
    var isArchived: Bool?
    var issuesEnabled: Bool?
    var mergeRequestsEnabled: Bool?
    var wikiEnabled: Bool?
    var buildsEnabled: Bool?
    var snippetsEnabled: Bool?
    var sharedRunnersEnabled: Bool?
    var creatorID: Int?
    var namespace: GitLabNamespace?
    var avatarURL: URL?
    var starCount: Int?
    var forksCount: Int?
    var openIssuesCount: Int?
    var runnersToken: String?
    var publicBuilds: Bool?
    var createdAt: Date?
    var lastActivityAt: Date?
    var lfsEnabled: Bool?
    var visibilityLevel: String?
    var onlyAllowMergeIfBuildSucceeds: Bool?
    var requestAccessEnabled: Bool?
    var permissions: String?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case nameWithNamespace = String(localized: "should_not_localize", defaultValue: "name_with_namespace", comment: "CodingKey for JSON - technical string, do not localize")
        case isPrivate = String(localized: "should_not_localize", defaultValue: "public", comment: "CodingKey for JSON - technical string, do not localize")
        case projectDescription = String(localized: "should_not_localize", defaultValue: "description", comment: "CodingKey for JSON - technical string, do not localize")
        case sshURL = String(localized: "should_not_localize", defaultValue: "ssh_url_to_repo", comment: "CodingKey for JSON - technical string, do not localize")
        case cloneURL = String(localized: "should_not_localize", defaultValue: "http_url_to_repo", comment: "CodingKey for JSON - technical string, do not localize")
        case webURL = String(localized: "should_not_localize", defaultValue: "web_url", comment: "CodingKey for JSON - technical string, do not localize")
        case path
        case pathWithNamespace = String(localized: "should_not_localize", defaultValue: "path_with_namespace", comment: "CodingKey for JSON - technical string, do not localize")
        case containerRegistryEnabled = String(localized: "should_not_localize", defaultValue: "container_registry_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case defaultBranch = String(localized: "should_not_localize", defaultValue: "default_branch", comment: "CodingKey for JSON - technical string, do not localize")
        case tagList = String(localized: "should_not_localize", defaultValue: "tag_list", comment: "CodingKey for JSON - technical string, do not localize")
        case isArchived = String(localized: "should_not_localize", defaultValue: "archived", comment: "CodingKey for JSON - technical string, do not localize")
        case issuesEnabled = String(localized: "should_not_localize", defaultValue: "issues_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case mergeRequestsEnabled = String(localized: "should_not_localize", defaultValue: "merge_requests_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case wikiEnabled = String(localized: "should_not_localize", defaultValue: "wiki_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case buildsEnabled = String(localized: "should_not_localize", defaultValue: "builds_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case snippetsEnabled = String(localized: "should_not_localize", defaultValue: "snippets_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case sharedRunnersEnabled = String(localized: "should_not_localize", defaultValue: "shared_runners_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case publicBuilds = String(localized: "should_not_localize", defaultValue: "public_builds", comment: "CodingKey for JSON - technical string, do not localize")
        case creatorID = String(localized: "should_not_localize", defaultValue: "creator_id", comment: "CodingKey for JSON - technical string, do not localize")
        case namespace
        case avatarURL = String(localized: "should_not_localize", defaultValue: "avatar_url", comment: "CodingKey for JSON - technical string, do not localize")
        case starCount = String(localized: "should_not_localize", defaultValue: "star_count", comment: "CodingKey for JSON - technical string, do not localize")
        case forksCount = String(localized: "should_not_localize", defaultValue: "forks_count", comment: "CodingKey for JSON - technical string, do not localize")
        case openIssuesCount = String(localized: "should_not_localize", defaultValue: "open_issues_count", comment: "CodingKey for JSON - technical string, do not localize")
        case visibilityLevel = String(localized: "should_not_localize", defaultValue: "visibility_level", comment: "CodingKey for JSON - technical string, do not localize")
        case createdAt = String(localized: "should_not_localize", defaultValue: "created_at", comment: "CodingKey for JSON - technical string, do not localize")
        case lastActivityAt = String(localized: "should_not_localize", defaultValue: "last_activity_at", comment: "CodingKey for JSON - technical string, do not localize")
        case lfsEnabled = String(localized: "should_not_localize", defaultValue: "lfs_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case runnersToken = String(localized: "should_not_localize", defaultValue: "runners_token", comment: "CodingKey for JSON - technical string, do not localize")
        case onlyAllowMergeIfBuildSucceeds = String(localized: "should_not_localize", defaultValue: "only_allow_merge_if_build_succeeds", comment: "CodingKey for JSON - technical string, do not localize")
        case requestAccessEnabled = String(localized: "should_not_localize", defaultValue: "request_access_enabled", comment: "CodingKey for JSON - technical string, do not localize")
        case permissions = String(localized: "should_not_localize", defaultValue: "permissions", comment: "CodingKey for JSON - technical string, do not localize")
    }
}
