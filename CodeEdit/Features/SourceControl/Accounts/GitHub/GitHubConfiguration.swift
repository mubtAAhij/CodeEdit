//
//  GitHubConfiguration.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct GitHubTokenConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.github
    var apiEndpoint: String?
    var accessToken: String?
    let errorDomain: String? = String(localized: "github.config.error.domain", defaultValue: "com.codeedit.models.accounts.github", comment: "Error domain identifier for GitHub account configuration")
    let authorizationHeader: String? = String(localized: "github.config.auth.header", defaultValue: "Basic", comment: "HTTP authorization header type for GitHub authentication")

    /// Custom `Accept` header for API previews.
    ///
    /// Used for preview support of new APIs, for instance Reaction API.
    /// see: https://developer.github.com/changes/2016-05-12-reactions-api-preview/
    private var previewCustomHeaders: [GitHTTPHeader]?

    var customHeaders: [GitHTTPHeader]? {
        /// More (non-preview) headers can be appended if needed in the future
        return previewCustomHeaders
    }

    init(_ token: String? = nil, url: String? = nil, previewHeaders: [GitHubPreviewHeader] = []) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        accessToken = token?.data(using: .utf8)!.base64EncodedString()
        previewCustomHeaders = previewHeaders.map { $0.header }
    }
}

struct GitHubOAuthConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.github
    var apiEndpoint: String?
    var accessToken: String?
    let token: String
    let secret: String
    let scopes: [String]
    let webEndpoint: String?
    let errorDomain = String(localized: "github.config.error.domain", defaultValue: "com.codeedit.models.accounts.github", comment: "Error domain identifier for GitHub account configuration")

    /// Custom `Accept` header for API previews.
    ///
    /// Used for preview support of new APIs, for instance Reaction API.
    /// see: https://developer.github.com/changes/2016-05-12-reactions-api-preview/
    private var previewCustomHeaders: [GitHTTPHeader]?

    var customHeaders: [GitHTTPHeader]? {
        /// More (non-preview) headers can be appended if needed in the future
        return previewCustomHeaders
    }

    init(
        _ url: String? = nil,
        webURL: String? = nil,
        token: String,
        secret: String,
        scopes: [String],
        previewHeaders: [GitHubPreviewHeader] = []
    ) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        webEndpoint = webURL ?? provider.baseURL?.absoluteString
        self.token = token
        self.secret = secret
        self.scopes = scopes
        previewCustomHeaders = previewHeaders.map { $0.header }
    }

    func authenticate() -> URL? {
        GitHubOAuthRouter.authorize(self).URLRequest?.url
    }

    func authorize(
        _ session: GitURLSession = URLSession.shared,
        code: String,
        completion: @escaping (_ config: GitHubTokenConfiguration) -> Void
    ) {
        let request = GitHubOAuthRouter.accessToken(self, code).URLRequest
        if let request {
            let task = session.dataTask(with: request) { data, response, _ in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        if let data,
                           let string = String(bytes: data, encoding: .utf8) {
                            let accessToken = self.accessTokenFromResponse(string)
                            if let accessToken {
                                let config = GitHubTokenConfiguration(accessToken, url: self.apiEndpoint ?? "")
                                completion(config)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func handleOpenURL(
        _ session: GitURLSession = URLSession.shared,
        url: URL,
        completion: @escaping (_ config: GitHubTokenConfiguration) -> Void
    ) {

        if let code = url.URLParameters[String(localized: "github.oauth.param.code", defaultValue: "code", comment: "OAuth parameter name for authorization code")] {
            authorize(session, code: code) { config in
                completion(config)
            }
        }
    }

    func accessTokenFromResponse(_ response: String) -> String? {
        let accessTokenParam = response.components(separatedBy: String(localized: "github.oauth.separator.ampersand", defaultValue: "&", comment: "URL parameter separator character")).first
        if let accessTokenParam {
            return accessTokenParam.components(separatedBy: String(localized: "github.oauth.separator.equals", defaultValue: "=", comment: "URL parameter key-value separator character")).last
        }
        return nil
    }
}

enum GitHubOAuthRouter: GitRouter {
    case authorize(GitHubOAuthConfiguration)
    case accessToken(GitHubOAuthConfiguration, String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .authorize(config): return config
        case let .accessToken(config, _): return config
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
            return String(localized: "github.oauth.path.authorize", defaultValue: "login/oauth/authorize", comment: "GitHub OAuth authorization endpoint path")
        case .accessToken:
            return String(localized: "github.oauth.path.access.token", defaultValue: "login/oauth/access_token", comment: "GitHub OAuth access token endpoint path")
        }
    }

    var params: [String: Any] {
        switch self {
        case let .authorize(config):
            let scope = (config.scopes as NSArray).componentsJoined(by: String(localized: "github.oauth.separator.comma", defaultValue: ",", comment: "Separator for joining OAuth scopes"))
            return [String(localized: "github.oauth.param.scope", defaultValue: "scope", comment: "OAuth parameter name for scope"): scope, String(localized: "github.oauth.param.client.id", defaultValue: "client_id", comment: "OAuth parameter name for client ID"): config.token, String(localized: "github.oauth.param.allow.signup", defaultValue: "allow_signup", comment: "OAuth parameter name for allow signup flag"): String(localized: "github.oauth.value.false", defaultValue: "false", comment: "Boolean false value for OAuth parameter")]
        case let .accessToken(config, code):
            return [String(localized: "github.oauth.param.client.id", defaultValue: "client_id", comment: "OAuth parameter name for client ID"): config.token, String(localized: "github.oauth.param.client.secret", defaultValue: "client_secret", comment: "OAuth parameter name for client secret"): config.secret, String(localized: "github.oauth.param.code", defaultValue: "code", comment: "OAuth parameter name for authorization code"): code]
        }
    }

    #if canImport(FoundationNetworking)
    typealias FoundationURLRequestType = FoundationNetworking.URLRequest
    #else
    typealias FoundationURLRequestType = Foundation.URLRequest
    #endif

    var URLRequest: FoundationURLRequestType? {
        switch self {
        case let .authorize(config):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case let .accessToken(config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint!)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}
