//
//  GitHubPullRequestRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanshi Li on 2022/03/31.
//

import Foundation

enum GitHubPullRequestRouter: GitJSONPostRouter {
    case readPullRequest(GitRouterConfiguration, String, String, String)
    case readPullRequests(
        GitRouterConfiguration, String, String, String?, String?, GitHubOpenness, GitSortType, GitSortDirection
    )

    var method: GitHTTPMethod {
        switch self {
        case .readPullRequest,
             .readPullRequests:
            return .GET
        }
    }

    var encoding: GitHTTPEncoding {
        switch self {
        default:
            return .url
        }
    }

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .readPullRequest(config, _, _, _): return config
        case let .readPullRequests(config, _, _, _, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readPullRequest:
            return [:]
        case let .readPullRequests(_, _, _, base, head, state, sort, direction):
            var parameters = [
                String(localized: "github.api.param.state", defaultValue: "state", comment: "GitHub API state parameter"): state.rawValue,
                String(localized: "github.api.param.sort", defaultValue: "sort", comment: "GitHub API sort parameter"): sort.rawValue,
                String(localized: "github.api.param.direction", defaultValue: "direction", comment: "GitHub API direction parameter"): direction.rawValue
            ]

            if let base {
                parameters[String(localized: "github.api.param.base", defaultValue: "base", comment: "GitHub API base parameter")] = base
            }

            if let head {
                parameters[String(localized: "github.api.param.head", defaultValue: "head", comment: "GitHub API head parameter")] = head
            }

            return parameters
        }
    }

    var path: String {
        switch self {
        case let .readPullRequest(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case let .readPullRequests(_, owner, repository, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        }
    }
}
