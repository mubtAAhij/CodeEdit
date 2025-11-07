//
//  BitBucketUserRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum BitBucketUserRouter: GitRouter {
    case readAuthenticatedUser(GitRouterConfiguration)
    case readEmails(GitRouterConfiguration)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .readAuthenticatedUser(let config): return config
        case .readEmails(let config): return config
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
            return String(localized: "source-control.bitbucket.endpoint.user", defaultValue: "user", comment: "BitBucket API endpoint path for authenticated user")
        case .readEmails:
            return "user/emails"
        }
    }

    var params: [String: Any] {
        [:]
    }
}
