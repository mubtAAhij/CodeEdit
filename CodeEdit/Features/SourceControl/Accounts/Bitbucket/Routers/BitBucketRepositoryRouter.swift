//
//  BitBucketRepositoryRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum BitBucketRepositoryRouter: GitRouter {
    case readRepositories(GitRouterConfiguration, String?, [String: String])
    case readRepository(GitRouterConfiguration, String, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .readRepositories(let config, _, _): return config
        case .readRepository(let config, _, _): return config
        }
    }

    var method: GitHTTPMethod {
        .GET
    }

    var encoding: GitHTTPEncoding {
        .url
    }

    var params: [String: Any] {
        switch self {
        case .readRepositories(_, let userName, var nextParameters):
            if userName != nil {
                return nextParameters as [String: Any]
            } else {
                nextParameters[String(localized: "bitbucket.api.param.role", defaultValue: "role", comment: "API parameter key for role")] = String(localized: "bitbucket.api.role.member", defaultValue: "member", comment: "API role value for member")
                return nextParameters as [String: Any]
            }
        case .readRepository:
            return [:]
        }
    }

    var path: String {
        switch self {
        case .readRepositories(_, let userName, _):
            if let userName {
                return String(format: String(localized: "bitbucket.api.path.user_repos", defaultValue: "repositories/%@", comment: "API path for user repositories"), userName)
            } else {
                return String(localized: "bitbucket.api.path.repos", defaultValue: "repositories", comment: "API path for repositories")
            }
        case let .readRepository(_, owner, name):
            return String(format: String(localized: "bitbucket.api.path.repo", defaultValue: "repositories/%@/%@", comment: "API path for specific repository"), owner, name)
        }
    }
}
