//
//  GitLabCommitRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitLabCommitRouter: GitRouter {
    case readCommits(GitRouterConfiguration, id: String, refName: String, since: String, until: String)
    case readCommit(GitRouterConfiguration, id: String, sha: String)
    case readCommitDiffs(GitRouterConfiguration, id: String, sha: String)
    case readCommitComments(GitRouterConfiguration, id: String, sha: String)
    case readCommitStatuses(
        GitRouterConfiguration,
        id: String,
        sha: String,
        ref: String,
        stage: String,
        name: String,
        all: Bool
    )

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .readCommits(config, _, _, _, _): return config
        case let .readCommit(config, _, _): return config
        case let .readCommitDiffs(config, _, _): return config
        case let .readCommitComments(config, _, _): return config
        case let .readCommitStatuses(config, _, _, _, _, _, _): return config
        }
    }

    var method: GitHTTPMethod {
        .GET
    }

    var encoding: GitHTTPEncoding {
        .url
    }

    var params: [String: Any] {
        switch self {
        case let .readCommits(_, _, refName, since, until):
            return [String(localized: "gitlab.commit.param.ref.name", defaultValue: "ref_name", comment: "GitLab commit reference name parameter"): refName, String(localized: "gitlab.commit.param.since", defaultValue: "since", comment: "GitLab commit since parameter"): since, String(localized: "gitlab.commit.param.until", defaultValue: "until", comment: "GitLab commit until parameter"): until]
        case .readCommit:
            return [:]
        case .readCommitDiffs:
            return [:]
        case .readCommitComments:
            return [:]
        case let .readCommitStatuses(_, _, _, ref, stage, name, all):
            return [String(localized: "gitlab.commit.param.ref", defaultValue: "ref", comment: "GitLab commit ref parameter"): ref, String(localized: "gitlab.commit.param.stage", defaultValue: "stage", comment: "GitLab commit stage parameter"): stage, String(localized: "gitlab.commit.param.name", defaultValue: "name", comment: "GitLab commit name parameter"): name, String(localized: "gitlab.commit.param.all", defaultValue: "all", comment: "GitLab commit all parameter"): String(all)]
        }
    }

    var path: String {
        switch self {
        case let .readCommits(_, id, _, _, _):
            return String(format: String(localized: "gitlab.commit.path.commits", defaultValue: "project/%@/repository/commits", comment: "GitLab commits endpoint path"), id)
        case let .readCommit(_, id, sha):
            return String(format: String(localized: "gitlab.commit.path.commit", defaultValue: "project/%@/repository/commits/%@", comment: "GitLab commit endpoint path"), id, sha)
        case let .readCommitDiffs(_, id, sha):
            return String(format: String(localized: "gitlab.commit.path.diff", defaultValue: "project/%@/repository/commits/%@/diff", comment: "GitLab commit diff endpoint path"), id, sha)
        case let .readCommitComments(_, id, sha):
            return String(format: String(localized: "gitlab.commit.path.comments", defaultValue: "project/%@/repository/commits/%@/comments", comment: "GitLab commit comments endpoint path"), id, sha)
        case let .readCommitStatuses(_, id, sha, _, _, _, _):
            return String(format: String(localized: "gitlab.commit.path.statuses", defaultValue: "project/%@/repository/commits/%@/statuses", comment: "GitLab commit statuses endpoint path"), id, sha)
        }
    }
}
