//
//  GitLabConfiguration.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

struct GitLabTokenConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.gitlab
    var apiEndpoint: String?
    var accessToken: String?
    let errorDomain: String? = String(localized: "gitlab.error_domain", defaultValue: "com.codeedit.models.accounts.gitlab", comment: "Error domain identifier - technical constant, not user-visible")

    init(_ token: String? = nil, url: String? = nil) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        accessToken = token
    }
}

struct GitLabPrivateTokenConfiguration: GitRouterConfiguration {
    let provider = SourceControlAccount.Provider.gitlab
    var apiEndpoint: String?
    var accessToken: String?
    let errorDomain: String? = String(localized: "gitlab.error_domain", defaultValue: "com.codeedit.models.accounts.gitlab", comment: "Error domain identifier - technical constant, not user-visible")

    init(_ token: String? = nil, url: String? = nil) {
        apiEndpoint = url ?? provider.apiURL?.absoluteString
        accessToken = token
    }

    var accessTokenFieldName: String {
        String(localized: "gitlab.api.field.private_token", defaultValue: "private_token", comment: "GitLab API authentication field name - technical constant, not user-visible")
    }
}
