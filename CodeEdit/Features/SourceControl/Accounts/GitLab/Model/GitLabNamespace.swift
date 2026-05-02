//
//  GitLabNamespace.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabNamespace: Codable {
    var id: Int?
    var name: String?
    var path: String?
    var ownerID: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var namespaceDescription: String?
    var avatar: GitLabAvatarURL?
    var shareWithGroupLocked: Bool?
    var visibilityLevel: Int?
    var requestAccessEnabled: Bool?
    var deletedAt: Date?
    var lfsEnabled: Bool?

    init(_ json: [String: AnyObject]) {
        if let id = json[String(localized: "gitlab.namespace.id", defaultValue: "id", comment: "GitLab namespace ID field")] as? Int {
            self.id = id
            name = json[String(localized: "gitlab.namespace.name", defaultValue: "name", comment: "GitLab namespace name field")] as? String
            path = json[String(localized: "gitlab.namespace.path", defaultValue: "path", comment: "GitLab namespace path field")] as? String
            ownerID = json[String(localized: "gitlab.namespace.owner.id", defaultValue: "owner_id", comment: "GitLab namespace owner ID field")] as? Int
            createdAt = GitTime.rfc3339Date(json[String(localized: "gitlab.namespace.created.at", defaultValue: "created_at", comment: "GitLab namespace created at field")] as? String)
            updatedAt = GitTime.rfc3339Date(json[String(localized: "gitlab.namespace.updated.at", defaultValue: "updated_at", comment: "GitLab namespace updated at field")] as? String)
            namespaceDescription = json[String(localized: "gitlab.namespace.description", defaultValue: "description", comment: "GitLab namespace description field")] as? String
            avatar = GitLabAvatarURL(json[String(localized: "gitlab.namespace.avatar", defaultValue: "avatar", comment: "GitLab namespace avatar field")] as? [String: AnyObject] ?? [:])
            shareWithGroupLocked = json[String(localized: "gitlab.namespace.share.with.group.lock", defaultValue: "share_with_group_lock", comment: "GitLab namespace share with group lock field")] as? Bool
            visibilityLevel = json[String(localized: "gitlab.namespace.visibility.level", defaultValue: "visibility_level", comment: "GitLab namespace visibility level field")] as? Int
            requestAccessEnabled = json[String(localized: "gitlab.namespace.request.access.enabled", defaultValue: "request_access_enabled", comment: "GitLab namespace request access enabled field")] as? Bool
            deletedAt = GitTime.rfc3339Date(json[String(localized: "gitlab.namespace.deleted.at", defaultValue: "deleted_at", comment: "GitLab namespace deleted at field")] as? String)
            lfsEnabled = json[String(localized: "gitlab.namespace.lfs.enabled", defaultValue: "lfs_enabled", comment: "GitLab namespace LFS enabled field")] as? Bool
        }
    }
}
