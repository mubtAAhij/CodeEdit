//
//  GitLabCommit.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabCommit: Codable {
    var id: String
    var shortID: String?
    var title: String?
    var authorName: String?
    var authorEmail: String?
    var committerName: String?
    var committerEmail: String?
    var createdAt: Date?
    var message: String?
    var committedDate: Date?
    var authoredDate: Date?
    var parentIDs: [String]?
    var stats: GitLabCommitStats?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shortID = String(localized: "should_not_localize", defaultValue: "short_id", comment: "CodingKey for JSON serialization - technical string")
        case title
        case authorName = String(localized: "should_not_localize", defaultValue: "author_name", comment: "CodingKey for JSON serialization - technical string")
        case authorEmail = String(localized: "should_not_localize", defaultValue: "author_email", comment: "CodingKey for JSON serialization - technical string")
        case committerName = String(localized: "should_not_localize", defaultValue: "committer_name", comment: "CodingKey for JSON serialization - technical string")
        case committerEmail = String(localized: "should_not_localize", defaultValue: "committer_email", comment: "CodingKey for JSON serialization - technical string")
        case createdAt = String(localized: "should_not_localize", defaultValue: "created_at", comment: "CodingKey for JSON serialization - technical string")
        case message
        case committedDate = String(localized: "should_not_localize", defaultValue: "committed_date", comment: "CodingKey for JSON serialization - technical string")
        case authoredDate = String(localized: "should_not_localize", defaultValue: "authored_date", comment: "CodingKey for JSON serialization - technical string")
        case parentIDs = String(localized: "should_not_localize", defaultValue: "parent_ids", comment: "CodingKey for JSON serialization - technical string")
        case stats
        case status
    }
}

class GitLabCommitStats: Codable {
    var additions: Int?
    var deletions: Int?
    var total: Int?

    enum CodingKeys: String, CodingKey {
        case additions
        case deletions
        case total
    }
}

class GitLabCommitDiff: Codable {
    var diff: String?
    var newPath: String?
    var oldPath: String?
    var aMode: String?
    var bMode: String?
    var newFile: Bool?
    var renamedFile: Bool?
    var deletedFile: Bool?

    enum CodingKeys: String, CodingKey {
        case diff
        case newPath = String(localized: "should_not_localize", defaultValue: "new_path", comment: "CodingKey for JSON serialization - technical string")
        case oldPath = String(localized: "should_not_localize", defaultValue: "old_path", comment: "CodingKey for JSON serialization - technical string")
        case aMode = String(localized: "should_not_localize", defaultValue: "a_mode", comment: "CodingKey for JSON serialization - technical string")
        case bMode = String(localized: "should_not_localize", defaultValue: "b_mode", comment: "CodingKey for JSON serialization - technical string")
        case newFile = String(localized: "should_not_localize", defaultValue: "new_file", comment: "CodingKey for JSON serialization - technical string")
        case renamedFile = String(localized: "should_not_localize", defaultValue: "renamed_file", comment: "CodingKey for JSON serialization - technical string")
        case deletedFile = String(localized: "should_not_localize", defaultValue: "deleted_file", comment: "CodingKey for JSON serialization - technical string")
    }
}

class GitLabCommitComment: Codable {
    var note: String?
    var author: GitLabUser?

    enum CodingKeys: String, CodingKey {
        case note
        case author
    }
}

class GitLabCommitStatus: Codable {
    var status: String?
    var createdAt: Date?
    var startedAt: Date?
    var name: String?
    var allowFailure: Bool?
    var author: GitLabUser?
    var statusDescription: String?
    var sha: String?
    var targetURL: URL?
    var finishedAt: Date?
    var id: Int?
    var ref: String?

    enum CodingKeys: String, CodingKey {
        case status
        case createdAt = String(localized: "should_not_localize", defaultValue: "created_at", comment: "CodingKey for JSON serialization - technical string")
        case startedAt = String(localized: "should_not_localize", defaultValue: "started_at", comment: "CodingKey for JSON serialization - technical string")
        case name
        case allowFailure = String(localized: "should_not_localize", defaultValue: "allow_failure", comment: "CodingKey for JSON serialization - technical string")
        case author
        case statusDescription = String(localized: "should_not_localize", defaultValue: "description", comment: "CodingKey for JSON serialization - technical string")
        case sha
        case targetURL = "target_url"
        case finishedAt = "finished_at"
        case id
        case ref
    }
}

extension GitLabAccount {

    /**
     Get a list of repository commits in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter refName: The name of a repository branch or tag or if not given the default branch.
     - parameter since: Only commits after or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
     - parameter until: Only commits before or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func commits(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        refName: String = "",
        since: String = "",
        until: String = "",
        completion: @escaping (_ response: Result<GitLabCommit, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabCommitRouter.readCommits(
            self.configuration,
            id: id,
            refName: refName,
            since: since,
            until: until
        )

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabCommit.self
        ) { json, error in

            if let error {
                completion(Result.failure(error))
            }

            if let json {
                completion(Result.success(json))
            }
        }
    }

    /**
     Get a specific commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func commit(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        sha: String,
        completion: @escaping (_ response: Result<GitLabCommit, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabCommitRouter.readCommit(self.configuration, id: id, sha: sha)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabCommit.self
        ) { json, error in

            if let error {
                completion(Result.failure(error))
            }

            if let json {
                completion(Result.success(json))
            }
        }
    }

    /**
     Get a diff of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func commitDiffs(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        sha: String,
        completion: @escaping (_ response: Result<GitLabCommitDiff, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabCommitRouter.readCommitDiffs(self.configuration, id: id, sha: sha)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabCommitDiff.self
        ) { json, error in

            if let error {
                completion(Result.failure(error))
            }

            if let json {
                completion(Result.success(json))
            }
        }
    }

    /**
     Get the comments of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func commitComments(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        sha: String,
        completion: @escaping (_ response: Result<GitLabCommitComment, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabCommitRouter.readCommitComments(self.configuration, id: id, sha: sha)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabCommitComment.self
        ) { json, error in

            if let error {
                completion(Result.failure(error))
            }

            if let json {
                completion(Result.success(json))
            }
        }
    }

    /**
     Get the statuses of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter ref: The name of a repository branch or tag or, if not given, the default branch.
     - parameter stage: Filter by build stage, e.g. `test`.
     - parameter name: Filter by job name, e.g. `bundler:audit`.
     - parameter all: Return all statuses, not only the latest ones. (Boolean value)
     - parameter completion: Callback for the outcome of the fetch.
     */
    func commitStatuses(
        _ session: GitURLSession = URLSession.shared,
        id: String,
        sha: String,
        ref: String = "",
        stage: String = "",
        name: String = "",
        all: Bool = false,
        completion: @escaping (_ response: Result<GitLabCommitStatus, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = GitLabCommitRouter.readCommitStatuses(
            self.configuration, id: id,
            sha: sha,
            ref: ref,
            stage: stage,
            name: name,
            all: all
        )

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: GitLabCommitStatus.self
        ) { json, error in

            if let error {
                completion(Result.failure(error))
            }

            if let json {
                completion(Result.success(json))
            }
        }
    }
}
