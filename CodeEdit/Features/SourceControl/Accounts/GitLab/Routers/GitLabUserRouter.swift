//
//  GitLabUserRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitLabUserRouter: GitRouter {
    case readAuthenticatedUser(GitRouterConfiguration)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .readAuthenticatedUser(let config): return config
        }
    }

    var method: GitHTTPMethod {
        .GET
    }

    var encoding: GitHTTPEncoding {
        .url
    }

    var path: String {
        switch self {
        case .readAuthenticatedUser:
            return String(localized: "api.gitlab.path.user", defaultValue: "user", comment: "GitLab API path for authenticated user endpoint")
        }
    }

    var params: [String: Any] {
        [:]
    }
}
