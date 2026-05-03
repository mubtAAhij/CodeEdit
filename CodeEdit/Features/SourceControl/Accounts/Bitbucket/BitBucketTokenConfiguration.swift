//
//  BitBucketTokenConfiguration.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

struct BitBucketTokenConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.bitbucketCloud
    var apiEndpoint: String?
    var accessToken: String?
    var refreshToken: String?
    var expirationDate: Date?
    let errorDomain = String(localized: "bitbucket.error_domain", defaultValue: "com.codeedit.models.accounts.bitbucket", comment: "Error domain identifier for Bitbucket - technical constant")

    init(json: [String: AnyObject], url: String? = nil) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        accessToken = json[String(localized: "bitbucket.oauth.access_token", defaultValue: "access_token", comment: "OAuth response key for access token - technical constant")] as? String
        refreshToken = json[String(localized: "bitbucket.oauth.refresh_token", defaultValue: "refresh_token", comment: "OAuth response key for refresh token - technical constant")] as? String
        let expiresIn = json[String(localized: "bitbucket.oauth.expires_in", defaultValue: "expires_in", comment: "OAuth response key for expiration time - technical constant")] as? Int
        let currentDate = Date()
        expirationDate = currentDate.addingTimeInterval(TimeInterval(expiresIn ?? 0))
    }

    init(
        _ token: String? = nil,
        refreshToken: String? = nil,
        expirationDate: Date? = nil,
        url: String? = nil
    ) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        accessToken = token
        self.expirationDate = expirationDate
        self.refreshToken = refreshToken
    }
}
