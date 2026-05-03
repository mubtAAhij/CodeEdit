//
//  BitBucketOAuthConfiguration.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

struct BitBucketOAuthConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.bitbucketCloud
    var apiEndpoint: String?
    var accessToken: String?
    let token: String
    let secret: String
    let scopes: [String]
    let webEndpoint: String?
    let errorDomain = String(localized: "bitbucket.error_domain", defaultValue: "com.codeedit.models.accounts.bitbucket", comment: "Bitbucket error domain")

    init(
        _ url: String? = nil,
        webURL: String? = nil,
        token: String,
        secret: String,
        scopes: [String]
    ) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        webEndpoint = webURL ?? provider.baseURL?.absoluteString
        self.token = token
        self.secret = secret
        self.scopes = []
    }

    func authenticate() -> URL? {
        BitBucketOAuthRouter.authorize(self).URLRequest?.url
    }

    fileprivate func basicAuthenticationString() -> String {
        let clientIDSecretString = [token, secret].joined(separator: String(localized: "bitbucket.auth.separator", defaultValue: ":", comment: "Auth separator colon"))
        let clientIDSecretData = clientIDSecretString.data(using: String.Encoding.utf8)
        let base64 = clientIDSecretData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return "Basic \(base64 ?? "")"
    }

    func basicAuthConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [String(localized: "bitbucket.auth.header_name", defaultValue: "Authorization", comment: "Authorization header name"): basicAuthenticationString()]
        return config
    }

    func authorize(
        _ session: GitURLSession,
        code: String,
        completion: @escaping (_ config: BitBucketTokenConfiguration) -> Void
    ) {
        let request = BitBucketOAuthRouter.accessToken(self, code).URLRequest

        if let request {
            let task = session.dataTask(with: request) { data, response, _ in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        if let config = self.configFromData(data) {
                            completion(config)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func configFromData(_ data: Data?) -> BitBucketTokenConfiguration? {
        guard let data else { return nil }
        do {
            guard let json = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: AnyObject] else {
                return nil
            }
            let config = BitBucketTokenConfiguration(json: json)
            return config
        } catch {
            return nil
        }
    }

    func handleOpenURL(
        _ session: GitURLSession = URLSession.shared,
        url: URL,
        completion: @escaping (_ config: BitBucketTokenConfiguration) -> Void
    ) {
        let params = url.bitbucketURLParameters()

        if let code = params[String(localized: "bitbucket.oauth.code_param", defaultValue: "code", comment: "OAuth code parameter")] {
            authorize(session, code: code) { config in
                completion(config)
            }
        }
    }

    func accessTokenFromResponse(_ response: String) -> String? {
        let accessTokenParam = response.components(separatedBy: String(localized: "bitbucket.oauth.param_separator", defaultValue: "&", comment: "OAuth parameter separator")).first
        if let accessTokenParam {
            return accessTokenParam.components(separatedBy: String(localized: "bitbucket.oauth.key_value_separator", defaultValue: "=", comment: "OAuth key-value separator")).last
        }
        return nil
    }
}
