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

        var displayName: String {
            String(localized: LocalizationValue(stringLiteral: "source-control.protocol.\(self.rawValue.lowercased())"), defaultValue: String.LocalizationValue(stringLiteral: self.rawValue), comment: "Protocol name")
        }
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
                return String(localized: "source-control.provider.id.bitbucket-cloud", defaultValue: "bitbucketCloud", comment: "Bitbucket Cloud provider ID")
            case .bitbucketServer:
                return String(localized: "source-control.provider.id.bitbucket-server", defaultValue: "bitbucketServer", comment: "Bitbucket Server provider ID")
            case .github:
                return String(localized: "source-control.provider.id.github", defaultValue: "github", comment: "GitHub provider ID")
            case .githubEnterprise:
                return String(localized: "source-control.provider.id.github-enterprise", defaultValue: "githubEnterprise", comment: "GitHub Enterprise provider ID")
            case .gitlab:
                return String(localized: "source-control.provider.id.gitlab", defaultValue: "gitlab", comment: "GitLab provider ID")
            case .gitlabSelfHosted:
                return String(localized: "source-control.provider.id.gitlab-self-hosted", defaultValue: "gitlabSelfHosted", comment: "GitLab Self-hosted provider ID")
            }
        }

        var name: String {
            switch self {
            case .bitbucketCloud:
                return String(localized: "source-control.provider.name.bitbucket-cloud", defaultValue: "BitBucket Cloud", comment: "Bitbucket Cloud provider name")
            case .bitbucketServer:
                return String(localized: "source-control.provider.name.bitbucket-server", defaultValue: "BitBucket Server", comment: "Bitbucket Server provider name")
            case .github:
                return String(localized: "source-control.provider.name.github", defaultValue: "GitHub", comment: "GitHub provider name")
            case .githubEnterprise:
                return String(localized: "source-control.provider.name.github-enterprise", defaultValue: "GitHub Enterprise", comment: "GitHub Enterprise provider name")
            case .gitlab:
                return String(localized: "source-control.provider.name.gitlab", defaultValue: "GitLab", comment: "GitLab provider name")
            case .gitlabSelfHosted:
                return String(localized: "source-control.provider.name.gitlab-self-hosted", defaultValue: "GitLab Self-hosted", comment: "GitLab Self-hosted provider name")
            }
        }

        var baseURL: URL? {
            switch self {
            case .bitbucketCloud:
                return URL(string: String(localized: "source-control.url.bitbucket-cloud-base", defaultValue: "https://www.bitbucket.com/", comment: "Bitbucket Cloud base URL"))!
            case .bitbucketServer:
                return nil
            case .github:
                return URL(string: String(localized: "source-control.url.github-base", defaultValue: "https://www.github.com/", comment: "GitHub base URL"))!
            case .githubEnterprise:
                return nil
            case .gitlab:
                return URL(string: String(localized: "source-control.url.gitlab-base", defaultValue: "https://www.gitlab.com/", comment: "GitLab base URL"))!
            case .gitlabSelfHosted:
                return nil
            }
        }

        var apiURL: URL? {
            switch self {
            case .bitbucketCloud:
                return URL(string: String(localized: "source-control.url.bitbucket-cloud-api", defaultValue: "https://api.bitbucket.org/2.0/", comment: "Bitbucket Cloud API URL"))!
            case .bitbucketServer:
                return nil
            case .github:
                return URL(string: String(localized: "source-control.url.github-api", defaultValue: "https://api.github.com/", comment: "GitHub API URL"))!
            case .githubEnterprise:
                return nil
            case .gitlab:
                return URL(string: String(localized: "source-control.url.gitlab-api", defaultValue: "https://gitlab.com/api/v4/", comment: "GitLab API URL"))!
            case .gitlabSelfHosted:
                return nil
            }
        }

        var iconResource: ImageResource {
            switch self {
            case .bitbucketCloud, .bitbucketServer:
                return .bitBucketIcon
            case .github, .githubEnterprise:
                return .gitHubIcon
            case .gitlab, .gitlabSelfHosted:
                return .gitLabIcon
            }
        }

        var authHelpURL: URL {
            switch self {
            case .bitbucketCloud:
                return URL(string: String(localized: "source-control.url.bitbucket-cloud-auth-help", defaultValue: "https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/", comment: "Bitbucket Cloud auth help URL"))!
            case .bitbucketServer:
                return URL(string: String(localized: "source-control.url.bitbucket-server-auth-help", defaultValue: "https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html", comment: "Bitbucket Server auth help URL"))!
            case .github:
                return URL(string: String(localized: "source-control.url.github-auth-help", defaultValue: "https://github.com/settings/tokens/new", comment: "GitHub auth help URL"))!
            case .githubEnterprise:
                return URL(string: String(localized: "source-control.url.github-enterprise-auth-help", defaultValue: "https://github.com/settings/tokens/new", comment: "GitHub Enterprise auth help URL"))!
            case .gitlab:
                return URL(string: String(localized: "source-control.url.gitlab-auth-help", defaultValue: "https://gitlab.com/-/profile/personal_access_tokens", comment: "GitLab auth help URL"))!
            case .gitlabSelfHosted:
                return URL(string: String(localized: "source-control.url.gitlab-self-hosted-auth-help", defaultValue: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html", comment: "GitLab Self-hosted auth help URL"))!
            }
        }

        var authType: AuthType {
            switch self {
            case .bitbucketCloud:
                return .password
            case .bitbucketServer:
                return .token
            case .github:
                return .token
            case .githubEnterprise:
                return .token
            case .gitlab:
                return .token
            case .gitlabSelfHosted:
                return .token
            }
        }
    }

    enum AuthType {
        case token
        case password
    }
}
