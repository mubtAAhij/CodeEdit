//
//  GitHubRepositoryRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanshi Li on 2022/03/31.
//

import Foundation

enum GitHubRepositoryRouter: GitRouter {
    case readRepositories(GitRouterConfiguration, String, String, String)
    case readAuthenticatedRepositories(GitRouterConfiguration, String, String)
    case readRepository(GitRouterConfiguration, String, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .readRepositories(config, _, _, _): return config
        case let .readAuthenticatedRepositories(config, _, _): return config
        case let .readRepository(config, _, _): return config
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
        case let .readRepositories(_, _, page, perPage):
            return [String(localized: "github.api.param.per_page", defaultValue: "per_page", comment: "GitHub API per_page parameter"): perPage, String(localized: "github.api.param.page", defaultValue: "page", comment: "GitHub API page parameter"): page]
        case let .readAuthenticatedRepositories(_, page, perPage):
            return [String(localized: "github.api.param.per_page", defaultValue: "per_page", comment: "GitHub API per_page parameter"): perPage, String(localized: "github.api.param.page", defaultValue: "page", comment: "GitHub API page parameter"): page]
        case .readRepository:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .readRepositories(_, owner, _, _):
            return "users/\(owner)/repos"
        case .readAuthenticatedRepositories:
            return String(localized: "github.api.path.authenticated_repos", defaultValue: "user/repos", comment: "GitHub API authenticated repos path")
        case let .readRepository(_, owner, name):
            return "repos/\(owner)/\(name)"
        }
    }
}
