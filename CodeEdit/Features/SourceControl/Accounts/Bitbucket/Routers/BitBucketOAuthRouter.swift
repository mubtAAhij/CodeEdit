//
//  BitBucketOAuthRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum BitBucketOAuthRouter: GitRouter {
    case authorize(BitBucketOAuthConfiguration)
    case accessToken(BitBucketOAuthConfiguration, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .authorize(let config): return config
        case .accessToken(let config, _): return config
        }
    }

    var method: GitHTTPMethod {
        switch self {
        case .authorize:
            return .GET
        case .accessToken:
            return .POST
        }
    }

    var encoding: GitHTTPEncoding {
        switch self {
        case .authorize:
            return .url
        case .accessToken:
            return .form
        }
    }

    var path: String {
        switch self {
        case .authorize:
            return String(localized: "swift.preflight.literal.437506", defaultValue: "site/oauth2/authorize", comment: "")
        case .accessToken:
            return String(localized: "swift.preflight.literal.437507", defaultValue: "site/oauth2/access_token", comment: "")
        }
    }

    var params: [String: Any] {
        switch self {
        case .authorize(let config):
            return [String(localized: "swift.preflight.literal.437508", defaultValue: "client_id", comment: ""): config.token, String(localized: "swift.preflight.literal.437509", defaultValue: "response_type", comment: ""): String(localized: "swift.preflight.literal.437510", defaultValue: "code", comment: "")]
        case .accessToken(_, let code):
            return [String(localized: "swift.preflight.literal.437511", defaultValue: "code", comment: ""): code, String(localized: "swift.preflight.literal.437512", defaultValue: "grant_type", comment: ""): String(localized: "swift.preflight.literal.437513", defaultValue: "authorization_code", comment: "")]
        }
    }

    var URLRequest: Foundation.URLRequest? {
        switch self {
        case .authorize(let config):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case .accessToken(let config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}
