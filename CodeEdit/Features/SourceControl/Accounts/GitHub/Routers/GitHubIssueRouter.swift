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
            return [String(localized: "should_not_localize", defaultValue: "per_page", comment: "API parameter name - technical string"): perPage, "page": page, "state": state.rawValue]
        case .readIssue:
            return [:]
        case let .readIssues(_, _, _, page, perPage, state):
            return [String(localized: "should_not_localize", defaultValue: "per_page", comment: "API parameter name - technical string"): perPage, "page": page, "state": state.rawValue]
        case let .postIssue(_, _, _, title, body, assignee, labels):
            var params: [String: Any] = [String(localized: "should_not_localize", defaultValue: "title", comment: "API parameter name - technical string"): title]
            if let body {
                params[String(localized: "should_not_localize", defaultValue: "body", comment: "API parameter name - technical string")] = body
            }
            if let assignee {
                params[String(localized: "should_not_localize", defaultValue: "assignee", comment: "API parameter name - technical string")] = assignee
            }
            if !labels.isEmpty {
                params[String(localized: "should_not_localize", defaultValue: "labels", comment: "API parameter name - technical string")] = labels
            }
            return params
        case let .patchIssue(_, _, _, _, title, body, assignee, state):
            var params: [String: String] = [:]
            if let title {
                params[String(localized: "should_not_localize", defaultValue: "title", comment: "API parameter name - technical string")] = title
            }
            if let body {
                params[String(localized: "should_not_localize", defaultValue: "body", comment: "API parameter name - technical string")] = body
            }
            if let assignee {
                params[String(localized: "should_not_localize", defaultValue: "assignee", comment: "API parameter name - technical string")] = assignee
            }
            if let state {
                params[String(localized: "should_not_localize", defaultValue: "state", comment: "API parameter name - technical string")] = state.rawValue
            }
            return params
        case let .commentIssue(_, _, _, _, body):
            return [String(localized: "should_not_localize", defaultValue: "body", comment: "API parameter name - technical string"): body]
        case let .readIssueComments(_, _, _, _, page, perPage):
            return [String(localized: "should_not_localize", defaultValue: "per_page", comment: "API parameter name - technical string"): perPage, "page": page]
        case let .patchIssueComment(_, _, _, _, body):
            return [String(localized: "should_not_localize", defaultValue: "body", comment: "API parameter name - technical string"): body]
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedIssues:
            return String(localized: "should_not_localize", defaultValue: "issues", comment: "API path segment - technical string")
        case let .readIssue(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        case let .readIssues(_, owner, repository, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case let .postIssue(_, owner, repository, _, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case let .patchIssue(_, owner, repository, number, _, _, _, _):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        case let .commentIssue(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/comments"
        case let .readIssueComments(_, owner, repository, number, _, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/comments"
        case let .patchIssueComment(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/comments/\(number)"
        }
    }
}
