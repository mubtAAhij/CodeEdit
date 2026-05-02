//
//  Repositories.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class GitHubRepositories: Codable {
    private(set) var id: Int = -1
    private(set) var owner = GitHubUser()
    var name: String?
    var fullName: String?
    private(set) var isPrivate: Bool = false
    var repositoryDescription: String?
    private(set) var isFork: Bool = false
    var gitURL: String?
    var sshURL: String?
    var cloneURL: String?
    var htmlURL: String?
    private(set) var size: Int? = -1
    var lastPush: Date?
    var stargazersCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case fullName = String(localized: "github.api.field.full.name", defaultValue: "full_name", comment: "GitHub API full_name field")
        case isPrivate = String(localized: "github.api.field.private", defaultValue: "private", comment: "GitHub API private field")
        case repositoryDescription = String(localized: "github.api.field.description", defaultValue: "description", comment: "GitHub API description field")
        case isFork = String(localized: "github.api.field.fork", defaultValue: "fork", comment: "GitHub API fork field")
        case gitURL = String(localized: "github.api.field.git.url", defaultValue: "git_url", comment: "GitHub API git_url field")
        case sshURL = String(localized: "github.api.field.ssh.url", defaultValue: "ssh_url", comment: "GitHub API ssh_url field")
        case cloneURL = String(localized: "github.api.field.clone.url", defaultValue: "clone_url", comment: "GitHub API clone_url field")
        case htmlURL = String(localized: "github.api.field.html.url", defaultValue: "html_url", comment: "GitHub API html_url field")
        case size
        case lastPush = String(localized: "github.api.field.pushed.at", defaultValue: "pushed_at", comment: "GitHub API pushed_at field")
        case stargazersCount = String(localized: "github.api.field.stargazers.count", defaultValue: "stargazers_count", comment: "GitHub API stargazers_count field")
    }
}

extension GitHubAccount {

    /**
        Fetches the Repositories for a user or organization
            - parameter session: GitURLSession, defaults to URLSession.shared
            - parameter owner: The user or organization that owns the repositories. If `nil`,
                               fetches repositories for the authenticated user.
            - parameter page: Current page for repository pagination. `1` by default.
            - parameter perPage: Number of repositories per page. `100` by default.
            - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func repositories(
        _ session: GitURLSession = URLSession.shared,
        owner: String? = nil,
        page: String = String(localized: "github.pagination.page.default", defaultValue: "1", comment: "GitHub pagination default page number"),
        perPage: String = String(localized: "github.pagination.perpage.default", defaultValue: "100", comment: "GitHub pagination default items per page"),
        completion: @escaping (_ response: Result<[GitHubRepositories], Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = (owner != nil)
            ? GitHubRepositoryRouter.readRepositories(configuration, owner!, page, perPage)
            : GitHubRepositoryRouter.readAuthenticatedRepositories(configuration, page, perPage)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: [GitHubRepositories].self
        ) { repos, error in
            if let error {
                completion(.failure(error))
            }

            if let repos {
                completion(.success(repos))
            }
        }
    }

    /**
         Fetches a repository for a user or organization
         - parameter session: GitURLSession, defaults to URLSession.shared
         - parameter owner: The user or organization that owns the repositories.
         - parameter name: The name of the repository to fetch.
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func repository(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        name: String,
        completion: @escaping (_ response: Result<GitHubRepositories, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubRepositoryRouter.readRepository(configuration, owner, name)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitHubRepositories.self
        ) { repo, error in
            if let error {
                completion(.failure(error))
            } else {
                if let repo {
                    completion(.success(repo))
                }
            }
        }
    }
}
