//
//  GitLabOAuthRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitLabOAuthRouter: GitRouter {
    case authorize(GitLabOAuthConfiguration, String)
    case accessToken(GitLabOAuthConfiguration, String, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .authorize(let config, _): return config
        case .accessToken(let config, _, _): return config
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
            return String(localized: "gitlab.oauth.authorize.path", defaultValue: "oauth/authorize", comment: "GitLab OAuth authorize endpoint path")
        case .accessToken:
            return String(localized: "gitlab.oauth.token.path", defaultValue: "oauth/token", comment: "GitLab OAuth token endpoint path")
        }
    }

    var params: [String: Any] {
        switch self {
        case let .authorize(config, redirectURI):
            return [
                String(localized: "gitlab.oauth.param.client.id", defaultValue: "client_id", comment: "OAuth client ID parameter"): config.token as AnyObject,
                String(localized: "gitlab.oauth.param.response.type", defaultValue: "response_type", comment: "OAuth response type parameter"): String(localized: "gitlab.oauth.param.code", defaultValue: "code", comment: "OAuth code parameter value") as AnyObject,
                String(localized: "gitlab.oauth.param.redirect.uri", defaultValue: "redirect_uri", comment: "OAuth redirect URI parameter"): redirectURI as AnyObject]
        case let .accessToken(config, code, rediredtURI):
            return [
                String(localized: "gitlab.oauth.param.client.id.token", defaultValue: "client_id", comment: "OAuth client ID parameter for token"): config.token as AnyObject,
                String(localized: "gitlab.oauth.param.client.secret", defaultValue: "client_secret", comment: "OAuth client secret parameter"): config.secret as AnyObject,
                String(localized: "gitlab.oauth.param.code.value", defaultValue: "code", comment: "OAuth code parameter"): code as AnyObject, String(localized: "gitlab.oauth.param.grant.type", defaultValue: "grant_type", comment: "OAuth grant type parameter"):
                    String(localized: "gitlab.oauth.param.authorization.code", defaultValue: "authorization_code", comment: "OAuth authorization code grant type") as AnyObject,
                String(localized: "gitlab.oauth.param.redirect.uri.token", defaultValue: "redirect_uri", comment: "OAuth redirect URI parameter for token"): rediredtURI as AnyObject]
        }
    }

    var URLRequest: Foundation.URLRequest? {
        switch self {
        case .authorize(let config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case .accessToken(let config, _, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}
