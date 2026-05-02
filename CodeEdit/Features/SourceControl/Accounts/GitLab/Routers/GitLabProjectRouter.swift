//
//  GitLabProjectRouter.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

enum GitLabVisibility: String {
    case visbilityPublic = "public"
    case visibilityInternal = "interal"
    case visibilityPrivate = "private"
    case all = ""

    var localizedValue: String {
        switch self {
        case .visbilityPublic:
            return String(localized: "gitlab.visibility.public", defaultValue: "public", comment: "GitLab public visibility")
        case .visibilityInternal:
            return String(localized: "gitlab.visibility.internal", defaultValue: "interal", comment: "GitLab internal visibility")
        case .visibilityPrivate:
            return String(localized: "gitlab.visibility.private", defaultValue: "private", comment: "GitLab private visibility")
        case .all:
            return ""
        }
    }
}

enum GitLabOrderBy: String {
    case id = "id"
    case name = "name"
    case path = "path"
    case creationDate = "created_at"
    case updateDate = "updated_at"
    case lastActvityDate = "last_activity_at"

    var localizedValue: String {
        switch self {
        case .id:
            return String(localized: "gitlab.order.by.id", defaultValue: "id", comment: "GitLab order by id")
        case .name:
            return String(localized: "gitlab.order.by.name", defaultValue: "name", comment: "GitLab order by name")
        case .path:
            return String(localized: "gitlab.order.by.path", defaultValue: "path", comment: "GitLab order by path")
        case .creationDate:
            return String(localized: "gitlab.order.by.created.at", defaultValue: "created_at", comment: "GitLab order by creation date")
        case .updateDate:
            return String(localized: "gitlab.order.by.updated.at", defaultValue: "updated_at", comment: "GitLab order by update date")
        case .lastActvityDate:
            return String(localized: "gitlab.order.by.last.activity.at", defaultValue: "last_activity_at", comment: "GitLab order by last activity date")
        }
    }
}

enum GitLabSort: String {
    case ascending = "asc"
    case descending = "desc"

    var localizedValue: String {
        switch self {
        case .ascending:
            return String(localized: "gitlab.sort.asc", defaultValue: "asc", comment: "GitLab ascending sort")
        case .descending:
            return String(localized: "gitlab.sort.desc", defaultValue: "desc", comment: "GitLab descending sort")
        }
    }
}

enum GitLabProjectRouter: GitRouter {
    case readAuthenticatedProjects(
        configuration: GitRouterConfiguration,
        page: String,
        perPage: String,
        archived: Bool,
        visibility: GitLabVisibility,
        orderBy: GitLabOrderBy,
        sort: GitLabSort,
        search: String,
        simple: Bool)
    case readVisibleProjects(
        configuration: GitRouterConfiguration,
        page: String,
        perPage: String,
        archived: Bool,
        visibility: GitLabVisibility,
        orderBy: GitLabOrderBy,
        sort: GitLabSort,
        search: String,
        simple: Bool)
    case readOwnedProjects(
        configuration: GitRouterConfiguration,
        page: String,
        perPage: String,
        archived: Bool,
        visibility: GitLabVisibility,
        orderBy: GitLabOrderBy,
        sort: GitLabSort,
        search: String,
        simple: Bool)
    case readStarredProjects(
        configuration: GitRouterConfiguration,
        page: String,
        perPage: String,
        archived: Bool,
        visibility: GitLabVisibility,
        orderBy: GitLabOrderBy,
        sort: GitLabSort,
        search: String,
        simple: Bool)
    case readAllProjects(
        configuration: GitRouterConfiguration,
        page: String,
        perPage: String,
        archived: Bool,
        visibility: GitLabVisibility,
        orderBy: GitLabOrderBy,
        sort: GitLabSort,
        search: String,
        simple: Bool)
    case readSingleProject(configuration: GitRouterConfiguration, id: String)
    case readProjectEvents(configuration: GitRouterConfiguration, id: String, page: String, perPage: String)
    case readProjectHooks(configuration: GitRouterConfiguration, id: String)
    case readProjectHook(configuration: GitRouterConfiguration, id: String, hookId: String)

    var configuration: GitRouterConfiguration? {
        switch self {
        case .readAuthenticatedProjects(let config, _, _, _, _, _, _, _, _): return config
        case .readVisibleProjects(let config, _, _, _, _, _, _, _, _): return config
        case .readOwnedProjects(let config, _, _, _, _, _, _, _, _): return config
        case .readStarredProjects(let config, _, _, _, _, _, _, _, _): return config
        case .readAllProjects(let config, _, _, _, _, _, _, _, _): return config
        case .readSingleProject(let config, _): return config
        case .readProjectEvents(let config, _, _, _): return config
        case .readProjectHooks(let config, _): return config
        case .readProjectHook(let config, _, _): return config
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
        case let .readAuthenticatedProjects(
            _,
            page,
            perPage,
            archived,
            visibility,
            orderBy,
            sort,
            search,
            simple
        ):
            return [
                String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page,
                String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage,
                String(localized: "gitlab.param.archived", defaultValue: "archived", comment: "GitLab API archived parameter"): String(archived),
                String(localized: "gitlab.param.visibility", defaultValue: "visibility", comment: "GitLab API visibility parameter"): visibility,
                String(localized: "gitlab.param.order.by", defaultValue: "order_by", comment: "GitLab API order by parameter"): orderBy,
                String(localized: "gitlab.param.sort", defaultValue: "sort", comment: "GitLab API sort parameter"): sort,
                String(localized: "gitlab.param.search", defaultValue: "search", comment: "GitLab API search parameter"): search,
                String(localized: "gitlab.param.simple", defaultValue: "simple", comment: "GitLab API simple parameter"): String(simple)
            ]
        case let .readVisibleProjects(
            _,
            page,
            perPage,
            archived,
            visibility,
            orderBy,
            sort,
            search,
            simple
        ):
            return [
                String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page,
                String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage,
                String(localized: "gitlab.param.archived", defaultValue: "archived", comment: "GitLab API archived parameter"): String(archived),
                String(localized: "gitlab.param.visibility", defaultValue: "visibility", comment: "GitLab API visibility parameter"): visibility,
                String(localized: "gitlab.param.order.by", defaultValue: "order_by", comment: "GitLab API order by parameter"): orderBy,
                String(localized: "gitlab.param.sort", defaultValue: "sort", comment: "GitLab API sort parameter"): sort,
                String(localized: "gitlab.param.search", defaultValue: "search", comment: "GitLab API search parameter"): search,
                String(localized: "gitlab.param.simple", defaultValue: "simple", comment: "GitLab API simple parameter"): String(simple)
            ]
        case let .readOwnedProjects(
            _,
            page,
            perPage,
            archived,
            visibility,
            orderBy,
            sort,
            search,
            simple
        ):
            return [
                String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page,
                String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage,
                String(localized: "gitlab.param.archived", defaultValue: "archived", comment: "GitLab API archived parameter"): String(archived),
                String(localized: "gitlab.param.visibility", defaultValue: "visibility", comment: "GitLab API visibility parameter"): visibility,
                String(localized: "gitlab.param.order.by", defaultValue: "order_by", comment: "GitLab API order by parameter"): orderBy,
                String(localized: "gitlab.param.sort", defaultValue: "sort", comment: "GitLab API sort parameter"): sort,
                String(localized: "gitlab.param.search", defaultValue: "search", comment: "GitLab API search parameter"): search,
                String(localized: "gitlab.param.simple", defaultValue: "simple", comment: "GitLab API simple parameter"): String(simple)
            ]
        case let .readStarredProjects(
            _,
            page,
            perPage,
            archived,
            visibility,
            orderBy,
            sort,
            search,
            simple
        ):
            return [
                String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page,
                String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage,
                String(localized: "gitlab.param.archived", defaultValue: "archived", comment: "GitLab API archived parameter"): String(archived),
                String(localized: "gitlab.param.visibility", defaultValue: "visibility", comment: "GitLab API visibility parameter"): visibility,
                String(localized: "gitlab.param.order.by", defaultValue: "order_by", comment: "GitLab API order by parameter"): orderBy,
                String(localized: "gitlab.param.sort", defaultValue: "sort", comment: "GitLab API sort parameter"): sort,
                String(localized: "gitlab.param.search", defaultValue: "search", comment: "GitLab API search parameter"): search,
                String(localized: "gitlab.param.simple", defaultValue: "simple", comment: "GitLab API simple parameter"): String(simple)
            ]
        case let .readAllProjects(
            _,
            page,
            perPage,
            archived,
            visibility,
            orderBy,
            sort,
            search,
            simple
        ):
            return [
                String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page,
                String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage,
                String(localized: "gitlab.param.archived", defaultValue: "archived", comment: "GitLab API archived parameter"): String(archived),
                String(localized: "gitlab.param.visibility", defaultValue: "visibility", comment: "GitLab API visibility parameter"): visibility,
                String(localized: "gitlab.param.order.by", defaultValue: "order_by", comment: "GitLab API order by parameter"): orderBy,
                String(localized: "gitlab.param.sort", defaultValue: "sort", comment: "GitLab API sort parameter"): sort,
                String(localized: "gitlab.param.search", defaultValue: "search", comment: "GitLab API search parameter"): search,
                String(localized: "gitlab.param.simple", defaultValue: "simple", comment: "GitLab API simple parameter"): String(simple)
            ]
        case .readSingleProject:
            return [:]
        case let .readProjectEvents(_, _, page, perPage):
            return [String(localized: "gitlab.param.per.page", defaultValue: "per_page", comment: "GitLab API per page parameter"): perPage, String(localized: "gitlab.param.page", defaultValue: "page", comment: "GitLab API page parameter"): page]
        case .readProjectHooks:
            return [:]
        case .readProjectHook:
            return [:]
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedProjects:
            return String(localized: "gitlab.path.projects", defaultValue: "projects", comment: "GitLab API projects endpoint")
        case .readVisibleProjects:
            return String(localized: "gitlab.path.projects.visible", defaultValue: "projects/visible", comment: "GitLab API visible projects endpoint")
        case .readOwnedProjects:
            return String(localized: "gitlab.path.projects.owned", defaultValue: "projects/owned", comment: "GitLab API owned projects endpoint")
        case .readStarredProjects:
            return String(localized: "gitlab.path.projects.starred", defaultValue: "projects/starred", comment: "GitLab API starred projects endpoint")
        case .readAllProjects:
            return String(localized: "gitlab.path.projects.all", defaultValue: "projects/all", comment: "GitLab API all projects endpoint")
        case .readSingleProject(_, let id):
            return String(format: String(localized: "gitlab.path.projects.id", defaultValue: "projects/%@", comment: "GitLab API single project endpoint"), id)
        case .readProjectEvents(_, let id, _, _):
            return String(format: String(localized: "gitlab.path.projects.id.events", defaultValue: "projects/%@/events", comment: "GitLab API project events endpoint"), id)
        case .readProjectHooks(_, let id):
            return String(format: String(localized: "gitlab.path.projects.id.hooks", defaultValue: "projects/%@/hooks", comment: "GitLab API project hooks endpoint"), id)
        case let .readProjectHook(_, id, hookId):
            return String(format: String(localized: "gitlab.path.projects.id.hooks.hookid", defaultValue: "projects/%@/hooks/%@", comment: "GitLab API single project hook endpoint"), id, hookId)
        }
    }
}
