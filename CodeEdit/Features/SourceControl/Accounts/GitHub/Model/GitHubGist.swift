//
//  GitHubGist.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class GitHubGist: Codable {
    typealias GitHubFiles = [String: GitHubFile]

    private(set) var id: String?
    var url: URL?
    var forksURL: URL?
    var commitsURL: URL?
    var gitPushURL: URL?
    var gitPullURL: URL?
    var commentsURL: URL?
    var htmlURL: URL?
    var files: GitHubFiles
    var publicGist: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var description: String?
    var comments: Int?
    var user: GitHubUser?
    var owner: GitHubUser?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case forksURL = String(localized: "github.gist.forks.url", defaultValue: "forks_url", comment: "GitHub gist forks URL field")
        case commitsURL = String(localized: "github.gist.commits.url", defaultValue: "commits_url", comment: "GitHub gist commits URL field")
        case gitPushURL = String(localized: "github.gist.git.pull.url", defaultValue: "git_pull_url", comment: "GitHub gist git pull URL field")
        case gitPullURL = String(localized: "github.gist.git.push.url", defaultValue: "git_push_url", comment: "GitHub gist git push URL field")
        case commentsURL = String(localized: "github.gist.comments.url", defaultValue: "comments_url", comment: "GitHub gist comments URL field")
        case htmlURL = String(localized: "github.gist.html.url", defaultValue: "html_url", comment: "GitHub gist HTML URL field")
        case files
        case publicGist = String(localized: "github.gist.public", defaultValue: "public", comment: "GitHub gist public field")
        case createdAt = String(localized: "github.gist.created.at", defaultValue: "created_at", comment: "GitHub gist created at field")
        case updatedAt = String(localized: "github.gist.updated.at", defaultValue: "updated_at", comment: "GitHub gist updated at field")
        case description
        case comments
        case user
        case owner
    }
}

extension GitHubAccount {

    /**
     Fetches the gists of the authenticated user
     - parameter session: GitURLSession, defaults to URLSession.sharedSession()
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myGists(
        _ session: GitURLSession = URLSession.shared,
        page: String = String(localized: "github.gist.default.page", defaultValue: "1", comment: "GitHub gist default page number"),
        perPage: String = String(localized: "github.gist.default.per.page", defaultValue: "100", comment: "GitHub gist default items per page"),
        completion: @escaping (_ response: Result<[GitHubGist], Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

        let router = GitHubGistRouter.readAuthenticatedGists(configuration, page, perPage)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: [GitHubGist].self
        ) { gists, error in

            if let error {
                completion(.failure(error))
            } else {
                if let gists {
                    completion(.success(gists))
                }
            }
        }
    }

    /**
     Fetches the gists of the specified user
     - parameter session: GitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The username who owns the gists.
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gists(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        page: String = String(localized: "github.gist.default.page", defaultValue: "1", comment: "GitHub gist default page number"),
        perPage: String = String(localized: "github.gist.default.per.page", defaultValue: "100", comment: "GitHub gist default items per page"),
        completion: @escaping (_ response: Result<[GitHubGist], Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

        let router = GitHubGistRouter.readGists(configuration, owner, page, perPage)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: [GitHubGist].self
        ) { gists, error in

            if let error {
                completion(.failure(error))
            } else {
                if let gists {
                    completion(.success(gists))
                }
            }
        }
    }

    /**
     Fetches an gist
     - parameter session: GitURLSession, defaults to URLSession.sharedSession()
     - parameter id: The id of the gist.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gist(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        completion: @escaping (_ response: Result<GitHubGist, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

        let router = GitHubGistRouter.readGist(configuration, id)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitHubGist.self
        ) { gist, error in

            if let error {
                completion(.failure(error))
            } else {
                if let gist {
                    completion(.success(gist))
                }
            }
        }
    }

    /**
     Creates an gist with a single file.
     - parameter session: GitURLSession, defaults to URLSession.sharedSession()
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter publicAccess: The public/private visibility of the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func postGistFile(
        _ session: GitURLSession = URLSession.shared,
        description: String,
        filename: String,
        fileContent: String,
        publicAccess: Bool,
        completion: @escaping (_ response: Result<GitHubGist, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

        let router = GitHubGistRouter.postGistFile(configuration, description, filename, fileContent, publicAccess)
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .formatted(GitTime.rfc3339DateFormatter)

        return router.post(
            session,
            decoder: decoder,
            expectedResultType: GitHubGist.self
        ) { gist, error in

            if let error {
                completion(.failure(error))
            } else {
                if let gist {
                    completion(.success(gist))
                }
            }
        }
    }

    /**
     Edits an gist with a single file.
     - parameter session: GitURLSession, defaults to URLSession.sharedSession()
     - parameter id: The of the gist to update.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func patchGistFile(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        description: String,
        filename: String,
        fileContent: String,
        completion: @escaping (_ response: Result<GitHubGist, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

        let router = GitHubGistRouter.patchGistFile(configuration, id, description, filename, fileContent)
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .formatted(GitTime.rfc3339DateFormatter)

        return router.post(
            session,
            decoder: decoder,
            expectedResultType: GitHubGist.self
        ) { gist, error in

            if let error {
                completion(.failure(error))
            } else {
                if let gist {
                    completion(.success(gist))
                }
            }
        }
    }
}
