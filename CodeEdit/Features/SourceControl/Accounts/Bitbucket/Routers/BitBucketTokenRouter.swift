//
//  BitBucketTokenRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum BitBucketTokenRouter: GitRouter {
    case refreshToken(BitBucketOAuthConfiguration, String)
    case emptyToken(BitBucketOAuthConfiguration, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .refreshToken(let config, _): return config
        default: return nil
        }
    }

    var method: GitHTTPMethod {
        .POST
    }

    var encoding: GitHTTPEncoding {
        .form
    }

    var params: [String: Any] {
        switch self {
        case .refreshToken(_, let token):
            return [String(localized: "bitbucket.oauth.param.refresh_token", defaultValue: "refresh_token", comment: "OAuth parameter key for refresh token - technical constant"): token, String(localized: "bitbucket.oauth.param.grant_type", defaultValue: "grant_type", comment: "OAuth parameter key for grant type - technical constant"): "refresh_token"]
        default: return ["": ""]
        }
    }

    var path: String {
        switch self {
        case .refreshToken:
            return String(localized: "bitbucket.oauth.endpoint", defaultValue: "site/oauth2/access_token", comment: "OAuth endpoint path - technical constant")
        default: return ""
        }
    }

    var URLRequest: Foundation.URLRequest? {
        switch self {
        case .refreshToken(let config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        default: return nil
        }
    }
}
