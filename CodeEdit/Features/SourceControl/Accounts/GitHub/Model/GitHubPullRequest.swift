//
//  GitHubPullRequest.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class GitHubPullRequest: Codable {
    private(set) var id: Int = -1
    var url: URL?

    var htmlURL: URL?
    var diffURL: URL?
    var patchURL: URL?
    var issueURL: URL?
    var commitsURL: URL?
    var reviewCommentsURL: URL?
    var reviewCommentURL: URL?
    var commentsURL: URL?
    var statusesURL: URL?

    var title: String?
    var body: String?

    var assignee: GitHubUser?

    var locked: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var closedAt: Date?
    var mergedAt: Date?

    var user: GitHubUser?
    var number: Int
    var state: GitHubOpenness?

    var head: GitHubPullRequest.Branch?
    var base: GitHubPullRequest.Branch?

    var requestedReviewers: [GitHubUser]?
    var draft: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case diffURL = String(localized: "github.pr.field.diff.url", defaultValue: "diff_url", comment: "GitHub API field name for pull request diff URL")
        case patchURL = String(localized: "github.pr.field.patch.url", defaultValue: "patch_url", comment: "GitHub API field name for pull request patch URL")
        case issueURL = String(localized: "github.pr.field.issue.url", defaultValue: "issue_url", comment: "GitHub API field name for pull request issue URL")
        case commitsURL = String(localized: "github.pr.field.commits.url", defaultValue: "commits_url", comment: "GitHub API field name for pull request commits URL")
        case reviewCommentsURL = String(localized: "github.pr.field.review.comments.url", defaultValue: "review_comments_url", comment: "GitHub API field name for pull request review comments URL")
        case commentsURL = String(localized: "github.pr.field.comments.url", defaultValue: "comments_url", comment: "GitHub API field name for pull request comments URL")
        case statusesURL = String(localized: "github.pr.field.statuses.url", defaultValue: "statuses_url", comment: "GitHub API field name for pull request statuses URL")
        case htmlURL = String(localized: "github.pr.field.html.url", defaultValue: "html_url", comment: "GitHub API field name for pull request HTML URL")
        case number
        case state
        case title
        case body
        case assignee
        case locked
        case user
        case closedAt = String(localized: "github.pr.field.closed.at", defaultValue: "closed_at", comment: "GitHub API field name for pull request closed date")
        case createdAt = String(localized: "github.pr.field.created.at", defaultValue: "created_at", comment: "GitHub API field name for pull request created date")
        case updatedAt = String(localized: "github.pr.field.updated.at", defaultValue: "updated_at", comment: "GitHub API field name for pull request updated date")
        case mergedAt = String(localized: "github.pr.field.merged.at", defaultValue: "merged_at", comment: "GitHub API field name for pull request merged date")
        case head
        case base
        case requestedReviewers = String(localized: "github.pr.field.requested.reviewers", defaultValue: "requested_reviewers", comment: "GitHub API field name for pull request requested reviewers")
        case draft
    }

    class Branch: Codable {
        var label: String?
        var ref: String?
        var sha: String?
        var user: GitHubUser?
        var repo: GitHubRepositories?
    }
}

extension GitHubAccount {

    /**
     Get a single pull request
     - parameter session: GitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to fetch.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequest(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        repository: String,
        number: Int,
        completion: @escaping (_ response: Result<GitHubPullRequest, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubPullRequestRouter.readPullRequest(configuration, owner, repository, String(format: String(localized: "github.pr.number.format", defaultValue: "%d", comment: "Format string for pull request number"), number))

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitHubPullRequest.self
        ) { pullRequest, error in

            if let error {
                completion(.failure(error))
            } else {
                if let pullRequest {
                    completion(.success(pullRequest))
                }
            }
        }
    }

    /**
     Get a list of pull requests
     - parameter session: GitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter base: Filter pulls by base branch name.
     - parameter head: Filter pulls by user or organization and branch name.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequests(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        repository: String,
        base: String? = nil,
        head: String? = nil,
        state: GitHubOpenness = .open,
        sort: GitSortType = .created,
        direction: GitSortDirection = .desc,
        completion: @escaping (_ response: Result<[GitHubPullRequest], Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubPullRequestRouter.readPullRequests(
            configuration,
            owner,
            repository,
            base,
            head,
            state,
            sort,
            direction
        )

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: [GitHubPullRequest].self
        ) { pullRequests, error in

            if let error {
                completion(.failure(error))
            } else {
                if let pullRequests {
                    completion(.success(pullRequests))
                }
            }
        }
    }
}
