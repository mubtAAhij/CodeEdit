//
//  GitHubGistRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanshi Li on 2022/03/31.
//

import Foundation

enum GitHubGistRouter: GitJSONPostRouter {
    case readAuthenticatedGists(GitRouterConfiguration, String, String)
    case readGists(GitRouterConfiguration, String, String, String)
    case readGist(GitRouterConfiguration, String)
    case postGistFile(GitRouterConfiguration, String, String, String, Bool)
    case patchGistFile(GitRouterConfiguration, String, String, String, String)

    var method: GitHTTPMethod {
        switch self {
        case .postGistFile, .patchGistFile:
            return .POST
        default:
            return .GET
        }
    }

    var encoding: GitHTTPEncoding {
        switch self {
        case .postGistFile, .patchGistFile:
            return .json
        default:
            return .url
        }
    }

    var configuration: GitRouterConfiguration? {
        switch self {
        case let .readAuthenticatedGists(config, _, _): return config
        case let .readGists(config, _, _, _): return config
        case let .readGist(config, _): return config
        case let .postGistFile(config, _, _, _, _): return config
        case let .patchGistFile(config, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .readAuthenticatedGists(_, page, perPage):
            return [String(localized: "github.gist.param.per.page", defaultValue: "per_page", comment: "GitHub API parameter for items per page"): perPage, String(localized: "github.gist.param.page", defaultValue: "page", comment: "GitHub API parameter for page number"): page]
        case let .readGists(_, _, page, perPage):
            return [String(localized: "github.gist.param.per.page", defaultValue: "per_page", comment: "GitHub API parameter for items per page"): perPage, String(localized: "github.gist.param.page", defaultValue: "page", comment: "GitHub API parameter for page number"): page]
        case .readGist:
            return [:]
        case let .postGistFile(_, description, filename, fileContent, publicAccess):
            var params = [String: Any]()
            params[String(localized: "github.gist.param.public", defaultValue: "public", comment: "GitHub API parameter for public gist visibility")] = publicAccess
            params[String(localized: "github.gist.param.description", defaultValue: "description", comment: "GitHub API parameter for gist description")] = description
            var file = [String: Any]()
            file[String(localized: "github.gist.param.content", defaultValue: "content", comment: "GitHub API parameter for file content")] = fileContent
            var files = [String: Any]()
            files[filename] = file
            params[String(localized: "github.gist.param.files", defaultValue: "files", comment: "GitHub API parameter for gist files")] = files
            return params
        case let .patchGistFile(_, _, description, filename, fileContent):
            var params = [String: Any]()
            params[String(localized: "github.gist.param.description", defaultValue: "description", comment: "GitHub API parameter for gist description")] = description
            var file = [String: Any]()
            file[String(localized: "github.gist.param.content", defaultValue: "content", comment: "GitHub API parameter for file content")] = fileContent
            var files = [String: Any]()
            files[filename] = file
            params[String(localized: "github.gist.param.files", defaultValue: "files", comment: "GitHub API parameter for gist files")] = files
            return params
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedGists:
            return String(localized: "github.gist.path.gists", defaultValue: "gists", comment: "GitHub API path for gists endpoint")
        case let .readGists(_, owner, _, _):
            return String(format: String(localized: "github.gist.path.user.gists", defaultValue: "users/%@/gists", comment: "GitHub API path for user gists endpoint"), owner)
        case let .readGist(_, id):
            return String(format: String(localized: "github.gist.path.gist.id", defaultValue: "gists/%@", comment: "GitHub API path for specific gist by ID"), id)
        case .postGistFile:
            return String(localized: "github.gist.path.gists", defaultValue: "gists", comment: "GitHub API path for gists endpoint")
        case let .patchGistFile(_, id, _, _, _):
            return String(format: String(localized: "github.gist.path.gist.id", defaultValue: "gists/%@", comment: "GitHub API path for specific gist by ID"), id)
        }
    }
}
