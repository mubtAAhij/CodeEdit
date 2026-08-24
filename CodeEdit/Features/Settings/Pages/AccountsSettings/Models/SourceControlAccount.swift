//
//  SourceControlAccount.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/6/23.
//

import SwiftUI

struct SourceControlAccount: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var provider: Provider
    var serverURL: String
    // TODO: Should we use an enum instead of a boolean here:
    // If true we use the HTTP protocol else if false we use SSH
    var urlProtocol: URLProtocol
    var sshKey: String
    var isTokenValid: Bool

    enum URLProtocol: String, Codable, CaseIterable {
        case https = "HTTPS"
        case ssh = "SSH"
    }

    enum Provider: Codable, CaseIterable, Identifiable {
        case bitbucketCloud
        case bitbucketServer
        case github
        case githubEnterprise
        case gitlab
        case gitlabSelfHosted

        var id: String {
            switch self {
            case .bitbucketCloud:
                "bitbucketCloud"
            case .bitbucketServer:
                "bitbucketServer"
            case .github:
                "github"
            case .githubEnterprise:
                "githubEnterprise"
            case .gitlab:
                "gitlab"
            case .gitlabSelfHosted:
                "gitlabSelfHosted"
            }
        }

        var name: String {
            switch self {
            case .bitbucketCloud:
                String(localized: "settings.accounts.source-control.bitbucket-cloud", defaultValue: "BitBucket Cloud", comment: "Display name for BitBucket Cloud source control provider")
            case .bitbucketServer:
                String(localized: "settings.accounts.source-control.bitbucket-server", defaultValue: "BitBucket Server", comment: "Display name for BitBucket Server source control provider")
            case .github:
                String(localized: "settings.accounts.source-control.github", defaultValue: "GitHub", comment: "Display name for GitHub source control provider")
            case .githubEnterprise:
                String(localized: "settings.accounts.source-control.github-enterprise", defaultValue: "GitHub Enterprise", comment: "Display name for GitHub Enterprise source control provider")
            case .gitlab:
                String(localized: "settings.accounts.source-control.gitlab", defaultValue: "GitLab", comment: "Display name for GitLab source control provider")
            case .gitlabSelfHosted:
                String(localized: "settings.accounts.source-control.gitlab-self-hosted", defaultValue: "GitLab Self-hosted", comment: "Display name for self-hosted GitLab source control provider")
            }
        }

        var baseURL: URL? {
            switch self {
            case .bitbucketCloud:
                URL(string: "https://www.bitbucket.com/")!
            case .bitbucketServer:
                nil
            case .github:
                URL(string: "https://www.github.com/")!
            case .githubEnterprise:
                nil
            case .gitlab:
                URL(string: "https://www.gitlab.com/")!
            case .gitlabSelfHosted:
                nil
            }
        }

        var apiURL: URL? {
            switch self {
            case .bitbucketCloud:
                URL(string: "https://api.bitbucket.org/2.0/")!
            case .bitbucketServer:
                nil
            case .github:
                URL(string: "https://api.github.com/")!
            case .githubEnterprise:
                nil
            case .gitlab:
                URL(string: "https://gitlab.com/api/v4/")!
            case .gitlabSelfHosted:
                nil
            }
        }

        var iconResource: ImageResource {
            switch self {
            case .bitbucketCloud, .bitbucketServer:
                .bitBucketIcon
            case .github, .githubEnterprise:
                .gitHubIcon
            case .gitlab, .gitlabSelfHosted:
                .gitLabIcon
            }
        }

        var authHelpURL: URL {
            switch self {
            case .bitbucketCloud:
                URL(string: "https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/")!
            case .bitbucketServer:
                URL(string:
                    "https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html")!
            case .github:
                URL(string: "https://github.com/settings/tokens/new")!
            case .githubEnterprise:
                URL(string: "https://github.com/settings/tokens/new")!
            case .gitlab:
                URL(string: "https://gitlab.com/-/profile/personal_access_tokens")!
            case .gitlabSelfHosted:
                URL(string: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html")!
            }
        }

        var authType: AuthType {
            switch self {
            case .bitbucketCloud:
                .password
            case .bitbucketServer:
                .token
            case .github:
                .token
            case .githubEnterprise:
                .token
            case .gitlab:
                .token
            case .gitlabSelfHosted:
                .token
            }
        }
    }

    enum AuthType {
        case token
        case password
    }
}
