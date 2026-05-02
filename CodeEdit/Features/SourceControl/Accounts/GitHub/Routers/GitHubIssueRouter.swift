//
//  GitHubIssueRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitHubIssueRouter: GitJSONPostRouter {
    case readAuthenticatedIssues(GitRouterConfiguration, String, String, GitHubOpenness)
    case readIssue(GitRouterConfiguration, String, String, Int)
    case readIssues(GitRouterConfiguration, String, String, String, String, GitHubOpenness)
    case postIssue(GitRouterConfiguration, String, String, String, String?, String?, [String])
    case patchIssue(GitRouterConfiguration, String, String, Int, String?, String?, String?, GitHubOpenness?)
    case commentIssue(GitRouterConfiguration, String, String, Int, String)
    case readIssueComments(GitRouterConfiguration, String, String, Int, String, String)
    case patchIssueComment(GitRouterConfiguration, String, String, Int, String)

    var method: GitHTTPMethod {
        switch self {
        case .postIssue, .patchIssue, .commentIssue, .patchIssueComment:
            return .POST
        default:
            return .GET
        }
    }

    var encoding: GitHTTPEncoding {
        switch self {
        case .postIssue, .patchIssue, .commentIssue, .patchIssueComment:
            return .json
        default:
            return .url
        }
    }

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .readAuthenticatedIssues(config, _, _, _): return config
        case let .readIssue(config, _, _, _): return config
        case let .readIssues(config, _, _, _, _, _): return config
        case let .postIssue(config, _, _, _, _, _, _): return config
        case let .patchIssue(config, _, _, _, _, _, _, _): return config
        case let .commentIssue(config, _, _, _, _): return config
        case let .readIssueComments(config, _, _, _, _, _): return config
        case let .patchIssueComment(config, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .readAuthenticatedIssues(_, page, perPage, state):
            return [String(localized: "github.api.param.per.page", defaultValue: "per_page", comment: "GitHub API parameter for items per page"): perPage, String(localized: "github.api.param.page", defaultValue: "page", comment: "GitHub API parameter for page number"): page, String(localized: "github.api.param.state", defaultValue: "state", comment: "GitHub API parameter for issue state"): state.rawValue]
        case .readIssue:
            return [:]
        case let .readIssues(_, _, _, page, perPage, state):
            return [String(localized: "github.api.param.per.page", defaultValue: "per_page", comment: "GitHub API parameter for items per page"): perPage, String(localized: "github.api.param.page", defaultValue: "page", comment: "GitHub API parameter for page number"): page, String(localized: "github.api.param.state", defaultValue: "state", comment: "GitHub API parameter for issue state"): state.rawValue]
        case let .postIssue(_, _, _, title, body, assignee, labels):
            var params: [String: Any] = [String(localized: "github.api.param.title", defaultValue: "title", comment: "GitHub API parameter for issue title"): title]
            if let body {
                params[String(localized: "github.api.param.body", defaultValue: "body", comment: "GitHub API parameter for issue body")] = body
            }
            if let assignee {
                params[String(localized: "github.api.param.assignee", defaultValue: "assignee", comment: "GitHub API parameter for assignee")] = assignee
            }
            if !labels.isEmpty {
                params[String(localized: "github.api.param.labels", defaultValue: "labels", comment: "GitHub API parameter for labels")] = labels
            }
            return params
        case let .patchIssue(_, _, _, _, title, body, assignee, state):
            var params: [String: String] = [:]
            if let title {
                params[String(localized: "github.api.param.title", defaultValue: "title", comment: "GitHub API parameter for issue title")] = title
            }
            if let body {
                params[String(localized: "github.api.param.body", defaultValue: "body", comment: "GitHub API parameter for issue body")] = body
            }
            if let assignee {
                params[String(localized: "github.api.param.assignee", defaultValue: "assignee", comment: "GitHub API parameter for assignee")] = assignee
            }
            if let state {
                params[String(localized: "github.api.param.state", defaultValue: "state", comment: "GitHub API parameter for issue state")] = state.rawValue
            }
            return params
        case let .commentIssue(_, _, _, _, body):
            return [String(localized: "github.api.param.body", defaultValue: "body", comment: "GitHub API parameter for issue body"): body]
        case let .readIssueComments(_, _, _, _, page, perPage):
            return [String(localized: "github.api.param.per.page", defaultValue: "per_page", comment: "GitHub API parameter for items per page"): perPage, String(localized: "github.api.param.page", defaultValue: "page", comment: "GitHub API parameter for page number"): page]
        case let .patchIssueComment(_, _, _, _, body):
            return [String(localized: "github.api.param.body", defaultValue: "body", comment: "GitHub API parameter for issue body"): body]
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedIssues:
            return String(localized: "github.api.path.issues", defaultValue: "issues", comment: "GitHub API path for issues")
        case let .readIssue(_, owner, repository, number):
            return String(format: String(localized: "github.api.path.repo.issue", defaultValue: "repos/%@/%@/issues/%d", comment: "GitHub API path for specific issue"), owner, repository, number)
        case let .readIssues(_, owner, repository, _, _, _):
            return String(format: String(localized: "github.api.path.repo.issues", defaultValue: "repos/%@/%@/issues", comment: "GitHub API path for repository issues"), owner, repository)
        case let .postIssue(_, owner, repository, _, _, _, _):
            return String(format: String(localized: "github.api.path.repo.issues", defaultValue: "repos/%@/%@/issues", comment: "GitHub API path for repository issues"), owner, repository)
        case let .patchIssue(_, owner, repository, number, _, _, _, _):
            return String(format: String(localized: "github.api.path.repo.issue", defaultValue: "repos/%@/%@/issues/%d", comment: "GitHub API path for specific issue"), owner, repository, number)
        case let .commentIssue(_, owner, repository, number, _):
            return String(format: String(localized: "github.api.path.repo.issue.comments", defaultValue: "repos/%@/%@/issues/%d/comments", comment: "GitHub API path for issue comments"), owner, repository, number)
        case let .readIssueComments(_, owner, repository, number, _, _):
            return String(format: String(localized: "github.api.path.repo.issue.comments", defaultValue: "repos/%@/%@/issues/%d/comments", comment: "GitHub API path for issue comments"), owner, repository, number)
        case let .patchIssueComment(_, owner, repository, number, _):
            return String(format: String(localized: "github.api.path.repo.issue.comment", defaultValue: "repos/%@/%@/issues/comments/%d", comment: "GitHub API path for specific issue comment"), owner, repository, number)
        }
    }
}
