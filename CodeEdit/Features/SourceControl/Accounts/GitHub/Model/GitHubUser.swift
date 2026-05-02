//
//  GitHubUser.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class GitHubUser: Codable {
    private(set) var id: Int = -1
    var login: String?
    var avatarURL: String?
    var gravatarID: String?
    var type: String?
    var name: String?
    var company: String?
    var email: String?
    var numberOfPublicRepos: Int?
    var numberOfPublicGists: Int?
    var numberOfPrivateRepos: Int?
    var nodeID: String?
    var url: String?
    var htmlURL: String?
    var gistsURL: String?
    var starredURL: String?
    var subscriptionsURL: String?
    var reposURL: String?
    var eventsURL: String?
    var receivedEventsURL: String?
    var createdAt: Date?
    var updatedAt: Date?
    var numberOfPrivateGists: Int?
    var numberOfOwnPrivateRepos: Int?
    var twoFactorAuthenticationEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case type
        case name
        case company
        case email
        case numberOfPublicRepos = "public_repos"
        case numberOfPublicGists = "public_gists"
        case numberOfPrivateRepos = "total_private_repos"
        case nodeID = "node_id"
        case url
        case htmlURL = "html_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case numberOfPrivateGists = "private_gists"
        case numberOfOwnPrivateRepos = "owned_private_repos"
        case twoFactorAuthenticationEnabled = "two_factor_authentication"

        var stringValue: String {
            switch self {
            case .avatarURL:
                return String(localized: "github.user.field.avatar.url", defaultValue: "avatar_url", comment: "GitHub API field name for avatar URL")
            case .gravatarID:
                return String(localized: "github.user.field.gravatar.id", defaultValue: "gravatar_id", comment: "GitHub API field name for gravatar ID")
            case .numberOfPublicRepos:
                return String(localized: "github.user.field.public.repos", defaultValue: "public_repos", comment: "GitHub API field name for public repositories count")
            case .numberOfPublicGists:
                return String(localized: "github.user.field.public.gists", defaultValue: "public_gists", comment: "GitHub API field name for public gists count")
            case .numberOfPrivateRepos:
                return String(localized: "github.user.field.total.private.repos", defaultValue: "total_private_repos", comment: "GitHub API field name for total private repositories count")
            case .nodeID:
                return String(localized: "github.user.field.node.id", defaultValue: "node_id", comment: "GitHub API field name for node ID")
            case .htmlURL:
                return String(localized: "github.user.field.html.url", defaultValue: "html_url", comment: "GitHub API field name for HTML URL")
            case .gistsURL:
                return String(localized: "github.user.field.gists.url", defaultValue: "gists_url", comment: "GitHub API field name for gists URL")
            case .starredURL:
                return String(localized: "github.user.field.starred.url", defaultValue: "starred_url", comment: "GitHub API field name for starred URL")
            case .subscriptionsURL:
                return String(localized: "github.user.field.subscriptions.url", defaultValue: "subscriptions_url", comment: "GitHub API field name for subscriptions URL")
            case .reposURL:
                return String(localized: "github.user.field.repos.url", defaultValue: "repos_url", comment: "GitHub API field name for repositories URL")
            case .eventsURL:
                return String(localized: "github.user.field.events.url", defaultValue: "events_url", comment: "GitHub API field name for events URL")
            case .receivedEventsURL:
                return String(localized: "github.user.field.received.events.url", defaultValue: "received_events_url", comment: "GitHub API field name for received events URL")
            case .createdAt:
                return String(localized: "github.user.field.created.at", defaultValue: "created_at", comment: "GitHub API field name for creation timestamp")
            case .updatedAt:
                return String(localized: "github.user.field.updated.at", defaultValue: "updated_at", comment: "GitHub API field name for update timestamp")
            case .numberOfPrivateGists:
                return String(localized: "github.user.field.private.gists", defaultValue: "private_gists", comment: "GitHub API field name for private gists count")
            case .numberOfOwnPrivateRepos:
                return String(localized: "github.user.field.owned.private.repos", defaultValue: "owned_private_repos", comment: "GitHub API field name for owned private repositories count")
            case .twoFactorAuthenticationEnabled:
                return String(localized: "github.user.field.two.factor.authentication", defaultValue: "two_factor_authentication", comment: "GitHub API field name for two-factor authentication status")
            default:
                return rawValue
            }
        }
    }
}

extension GitHubAccount {
    /**
         Fetches a user or organization
         - parameter session: GitURLSession, defaults to URLSession.shared
         - parameter name: The name of the user or organization.
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func user(
        _ session: GitURLSession = URLSession.shared,
        name: String,
        completion: @escaping (_ response: Result<GitHubUser, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubUserRouter.readUser(name, configuration)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitHubUser.self
        ) { user, error in
            if let error {
                completion(.failure(error))
            } else {
                if let user {
                    completion(.success(user))
                }
            }
        }
    }

    /**
         Fetches the authenticated user
         - parameter session: GitURLSession, defaults to URLSession.shared
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func me(
        _ session: GitURLSession = URLSession.shared,
        completion: @escaping (_ response: Result<GitHubUser, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubUserRouter.readAuthenticatedUser(configuration)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitHubUser.self
        ) { user, error in
            if let error {
                completion(.failure(error))
            } else {
                if let user {
                    completion(.success(user))
                }
            }
        }
    }
}
