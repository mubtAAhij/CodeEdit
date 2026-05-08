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
        case shortID = String(localized: "skip", defaultValue: "short_id", comment: "CodingKey for JSON field")
        case title
        case authorName = String(localized: "skip", defaultValue: "author_name", comment: "CodingKey for JSON field")
        case authorEmail = String(localized: "skip", defaultValue: "author_email", comment: "CodingKey for JSON field")
        case committerName = String(localized: "skip", defaultValue: "committer_name", comment: "CodingKey for JSON field")
        case committerEmail = String(localized: "skip", defaultValue: "committer_email", comment: "CodingKey for JSON field")
        case createdAt = String(localized: "skip", defaultValue: "created_at", comment: "CodingKey for JSON field")
        case message
        case committedDate = String(localized: "skip", defaultValue: "committed_date", comment: "CodingKey for JSON field")
        case authoredDate = String(localized: "skip", defaultValue: "authored_date", comment: "CodingKey for JSON field")
        case parentIDs = String(localized: "skip", defaultValue: "parent_ids", comment: "CodingKey for JSON field")
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
        case newPath = String(localized: "skip", defaultValue: "new_path", comment: "CodingKey for JSON field")
        case oldPath = String(localized: "skip", defaultValue: "old_path", comment: "CodingKey for JSON field")
        case aMode = String(localized: "skip", defaultValue: "a_mode", comment: "CodingKey for JSON field")
        case bMode = String(localized: "skip", defaultValue: "b_mode", comment: "CodingKey for JSON field")
        case newFile = String(localized: "skip", defaultValue: "new_file", comment: "CodingKey for JSON field")
        case renamedFile = String(localized: "skip", defaultValue: "renamed_file", comment: "CodingKey for JSON field")
        case deletedFile = String(localized: "skip", defaultValue: "deleted_file", comment: "CodingKey for JSON field")
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
        case createdAt = String(localized: "skip", defaultValue: "created_at", comment: "CodingKey for JSON field")
        case startedAt = String(localized: "skip", defaultValue: "started_at", comment: "CodingKey for JSON field")
        case name
        case allowFailure = String(localized: "skip", defaultValue: "allow_failure", comment: "CodingKey for JSON field")
        case author
        case statusDescription = String(localized: "skip", defaultValue: "description", comment: "CodingKey for JSON field")
        case sha
        case targetURL = String(localized: "skip", defaultValue: "target_url", comment: "CodingKey for JSON field")
        case finishedAt = String(localized: "skip", defaultValue: "finished_at", comment: "CodingKey for JSON field")
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
