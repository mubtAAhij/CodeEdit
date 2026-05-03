//
//  GitHubReview.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// TODO: DOCS (Nanashi Li)
struct GitHubReview {
    let body: String
    let commitID: String
    let id: Int
    let state: State
    let submittedAt: Date
    let user: GitHubUser
}

extension GitHubReview: Codable {
    enum CodingKeys: String, CodingKey {
        case body
        case commitID = String(localized: "github.api.field.commit_id", defaultValue: "commit_id", comment: "GitHub API commit_id field")
        case id
        case state
        case submittedAt = String(localized: "github.api.field.submitted_at", defaultValue: "submitted_at", comment: "GitHub API submitted_at field")
        case user
    }
}

extension GitHubReview {
    enum State: String, Codable, Equatable {
        case approved = String(localized: "github.review.state.approved", defaultValue: "APPROVED", comment: "GitHub review approved state")
        case changesRequested = String(localized: "github.review.state.changes_requested", defaultValue: "CHANGES_REQUESTED", comment: "GitHub review changes requested state")
        case comment = String(localized: "github.review.state.commented", defaultValue: "COMMENTED", comment: "GitHub review commented state")
        case dismissed = String(localized: "github.review.state.dismissed", defaultValue: "DISMISSED", comment: "GitHub review dismissed state")
        case pending = String(localized: "github.review.state.pending", defaultValue: "PENDING", comment: "GitHub review pending state")
    }
}

extension GitHubAccount {

    @discardableResult
    func listReviews(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        repository: String,
        pullRequestNumber: Int,
        completion: @escaping (_ response: Result<[GitHubReview], Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitHubReviewsRouter.listReviews(configuration, owner, repository, pullRequestNumber)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: [GitHubReview].self
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
