//
//  GitLabOAuthConfiguration.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

struct GitLabOAuthConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.gitlab
    var apiEndpoint: String?
    var accessToken: String?
    let token: String
    let secret: String
    let redirectURI: String
    let webEndpoint: String?
    let errorDomain = String(localized: "gitlab.error_domain", defaultValue: "com.codeedit.models.accounts.gitlab", comment: "Error domain identifier - technical constant, not user-visible")

    init(
        _ url: String? = nil,
        webURL: String? = nil,
        token: String,
        secret: String,
        redirectURI: String
    ) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        webEndpoint = webURL ?? provider.baseURL?.absoluteString
        self.token = token
        self.secret = secret
        self.redirectURI = redirectURI
    }

    func authenticate() -> URL? {
        GitLabOAuthRouter.authorize(self, redirectURI).URLRequest?.url
    }

    func authorize(
        _ session: GitURLSession = URLSession.shared,
        code: String,
        completion: @escaping (_ config: GitLabTokenConfiguration) -> Void
    ) {
        let request = GitLabOAuthRouter.accessToken(self, code, redirectURI).URLRequest
        if let request {
            let task = session.dataTask(with: request) { data, response, _ in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        guard let data else {
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(
                                with: data,
                                options: .allowFragments
                            ) as? [String: Any]
                            if let json, let accessToken = json[String(localized: "gitlab.oauth.response.access_token", defaultValue: "access_token", comment: "JSON key for OAuth response - technical constant, not user-visible")] as? String {
                                let config = GitLabTokenConfiguration(accessToken, url: self.apiEndpoint ?? "")
                                completion(config)
                            }
                        } catch {
                            return
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
        completion: @escaping (_ config: GitLabTokenConfiguration) -> Void
    ) {
        if let code = url.absoluteString.components(separatedBy: String(localized: "url.delimiter.equals", defaultValue: "=", comment: "URL component delimiter - technical character, not user-visible")).last {
            authorize(session, code: code) { (config) in
                completion(config)
            }
        }
    }
}
