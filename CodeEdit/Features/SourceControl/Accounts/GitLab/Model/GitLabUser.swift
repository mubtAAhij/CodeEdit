//
//  GitLabUser.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabUser: Codable {
    var id: Int
    var username: String?
    var state: String?
    var avatarURL: URL?
    var webURL: URL?
    var createdAt: Date?
    var isAdmin: Bool?
    var name: String?
    var lastSignInAt: Date?
    var confirmedAt: Date?
    var email: String?
    var projectsLimit: Int?
    var currentSignInAt: Date?
    var canCreateGroup: Bool?
    var canCreateProject: Bool?
    var twoFactorEnabled: Bool?
    var external: Bool?

    init(_ json: [String: Any]) {
        if let id = json[String(localized: "gitlab.user.field.id", defaultValue: "id", comment: "GitLab API field name for user ID")] as? Int {
            name = json[String(localized: "gitlab.user.field.name", defaultValue: "name", comment: "GitLab API field name for user name")] as? String
            username = json[String(localized: "gitlab.user.field.username", defaultValue: "username", comment: "GitLab API field name for username")] as? String
            self.id = id
            state = json[String(localized: "gitlab.user.field.state", defaultValue: "state", comment: "GitLab API field name for user state")] as? String
            if let urlString = json[String(localized: "gitlab.user.field.avatar.url", defaultValue: "avatar_url", comment: "GitLab API field name for avatar URL")] as? String, let url = URL(string: urlString) {
                avatarURL = url
            }
            if let urlString = json[String(localized: "gitlab.user.field.web.url", defaultValue: "web_url", comment: "GitLab API field name for web URL")] as? String, let url = URL(string: urlString) {
                webURL = url
            }
            createdAt = GitTime.rfc3339Date(json[String(localized: "gitlab.user.field.created.at", defaultValue: "created_at", comment: "GitLab API field name for creation timestamp")] as? String)
            isAdmin = json[String(localized: "gitlab.user.field.is.admin", defaultValue: "is_admin", comment: "GitLab API field name for admin status")] as? Bool
            lastSignInAt = GitTime.rfc3339Date(json[String(localized: "gitlab.user.field.last.sign.in.at", defaultValue: "last_sign_in_at", comment: "GitLab API field name for last sign-in timestamp")] as? String)
            confirmedAt = GitTime.rfc3339Date(json[String(localized: "gitlab.user.field.confirmed.at", defaultValue: "confirmed_at", comment: "GitLab API field name for confirmation timestamp")] as? String)
            email = json[String(localized: "gitlab.user.field.email", defaultValue: "email", comment: "GitLab API field name for email address")] as? String
            projectsLimit = json[String(localized: "gitlab.user.field.projects.limit", defaultValue: "projects_limit", comment: "GitLab API field name for projects limit")] as? Int
            currentSignInAt = GitTime.rfc3339Date(json[String(localized: "gitlab.user.field.current.sign.in.at", defaultValue: "current_sign_in_at", comment: "GitLab API field name for current sign-in timestamp")] as? String)
            canCreateGroup = json[String(localized: "gitlab.user.field.can.create.group", defaultValue: "can_create_group", comment: "GitLab API field name for group creation permission")] as? Bool
            canCreateProject = json[String(localized: "gitlab.user.field.can.create.project", defaultValue: "can_create_project", comment: "GitLab API field name for project creation permission")] as? Bool
            twoFactorEnabled = json[String(localized: "gitlab.user.field.two.factor.enabled", defaultValue: "two_factor_enabled", comment: "GitLab API field name for two-factor authentication status")] as? Bool
            external = json[String(localized: "gitlab.user.field.external", defaultValue: "external", comment: "GitLab API field name for external user status")] as? Bool
        } else {
            id = -1
        }
    }
}

extension GitLabAccount {

    /**
     Fetches the currently logged in user
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func me(
        _ session: GitURLSession = URLSession.shared,
        completion: @escaping (_ response: Result<GitLabUser, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabUserRouter.readAuthenticatedUser(self.configuration)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabUser.self
        ) { data, error in

            if let error {
                completion(Result.failure(error))
            }

            if let data {
                completion(Result.success(data))
            }
        }
    }
}
