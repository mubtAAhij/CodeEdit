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
            return self.rawValue
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
                return String(localized: "source.control.provider.id.bitbucket.cloud", defaultValue: "bitbucketCloud", comment: "Provider ID for Bitbucket Cloud")
            case .bitbucketServer:
                return String(localized: "source.control.provider.id.bitbucket.server", defaultValue: "bitbucketServer", comment: "Provider ID for Bitbucket Server")
            case .github:
                return String(localized: "source.control.provider.id.github", defaultValue: "github", comment: "Provider ID for GitHub")
            case .githubEnterprise:
                return String(localized: "source.control.provider.id.github.enterprise", defaultValue: "githubEnterprise", comment: "Provider ID for GitHub Enterprise")
            case .gitlab:
                return String(localized: "source.control.provider.id.gitlab", defaultValue: "gitlab", comment: "Provider ID for GitLab")
            case .gitlabSelfHosted:
                return String(localized: "source.control.provider.id.gitlab.self.hosted", defaultValue: "gitlabSelfHosted", comment: "Provider ID for GitLab Self-hosted")
            }
        }

        var name: String {
            switch self {
            case .bitbucketCloud:
                return String(localized: "source.control.provider.name.bitbucket.cloud", defaultValue: "BitBucket Cloud", comment: "Display name for Bitbucket Cloud")
            case .bitbucketServer:
                return String(localized: "source.control.provider.name.bitbucket.server", defaultValue: "BitBucket Server", comment: "Display name for Bitbucket Server")
            case .github:
                return String(localized: "source.control.provider.name.github", defaultValue: "GitHub", comment: "Display name for GitHub")
            case .githubEnterprise:
                return String(localized: "source.control.provider.name.github.enterprise", defaultValue: "GitHub Enterprise", comment: "Display name for GitHub Enterprise")
            case .gitlab:
                return String(localized: "source.control.provider.name.gitlab", defaultValue: "GitLab", comment: "Display name for GitLab")
            case .gitlabSelfHosted:
                return String(localized: "source.control.provider.name.gitlab.self.hosted", defaultValue: "GitLab Self-hosted", comment: "Display name for GitLab Self-hosted")
            }
        }

        var baseURL: URL? {
            switch self {
            case .bitbucketCloud:
                return URL(string: String(localized: "source.control.provider.base.url.bitbucket.cloud", defaultValue: "https://www.bitbucket.com/", comment: "Base URL for Bitbucket Cloud"))!
            case .bitbucketServer:
                return nil
            case .github:
                return URL(string: String(localized: "source.control.provider.base.url.github", defaultValue: "https://www.github.com/", comment: "Base URL for GitHub"))!
            case .githubEnterprise:
                return nil
            case .gitlab:
                return URL(string: String(localized: "source.control.provider.base.url.gitlab", defaultValue: "https://www.gitlab.com/", comment: "Base URL for GitLab"))!
            case .gitlabSelfHosted:
                return nil
            }
        }

        var apiURL: URL? {
            switch self {
            case .bitbucketCloud:
                return URL(string: String(localized: "source.control.provider.api.url.bitbucket.cloud", defaultValue: "https://api.bitbucket.org/2.0/", comment: "API URL for Bitbucket Cloud"))!
            case .bitbucketServer:
                return nil
            case .github:
                return URL(string: String(localized: "source.control.provider.api.url.github", defaultValue: "https://api.github.com/", comment: "API URL for GitHub"))!
            case .githubEnterprise:
                return nil
            case .gitlab:
                return URL(string: String(localized: "source.control.provider.api.url.gitlab", defaultValue: "https://gitlab.com/api/v4/", comment: "API URL for GitLab"))!
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
                return URL(string: String(localized: "source.control.provider.auth.help.url.bitbucket.cloud", defaultValue: "https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/", comment: "Auth help URL for Bitbucket Cloud"))!
            case .bitbucketServer:
                return URL(string: String(localized: "source.control.provider.auth.help.url.bitbucket.server", defaultValue: "https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html", comment: "Auth help URL for Bitbucket Server"))!
            case .github:
                return URL(string: String(localized: "source.control.provider.auth.help.url.github", defaultValue: "https://github.com/settings/tokens/new", comment: "Auth help URL for GitHub"))!
            case .githubEnterprise:
                return URL(string: String(localized: "source.control.provider.auth.help.url.github.enterprise", defaultValue: "https://github.com/settings/tokens/new", comment: "Auth help URL for GitHub Enterprise"))!
            case .gitlab:
                return URL(string: String(localized: "source.control.provider.auth.help.url.gitlab", defaultValue: "https://gitlab.com/-/profile/personal_access_tokens", comment: "Auth help URL for GitLab"))!
            case .gitlabSelfHosted:
                return URL(string: String(localized: "source.control.provider.auth.help.url.gitlab.self.hosted", defaultValue: "https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html", comment: "Auth help URL for GitLab Self-hosted"))!
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
