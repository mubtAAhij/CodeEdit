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
        case shortID = String(localized: "gitlab.commit.key.short-id", defaultValue: "short_id", comment: "GitLab API key for commit short ID")
        case title
        case authorName = String(localized: "gitlab.commit.key.author-name", defaultValue: "author_name", comment: "GitLab API key for commit author name")
        case authorEmail = String(localized: "gitlab.commit.key.author-email", defaultValue: "author_email", comment: "GitLab API key for commit author email")
        case committerName = String(localized: "gitlab.commit.key.committer-name", defaultValue: "committer_name", comment: "GitLab API key for commit committer name")
        case committerEmail = String(localized: "gitlab.commit.key.committer-email", defaultValue: "committer_email", comment: "GitLab API key for commit committer email")
        case createdAt = String(localized: "gitlab.commit.key.created-at", defaultValue: "created_at", comment: "GitLab API key for commit created date")
        case message
        case committedDate = String(localized: "gitlab.commit.key.committed-date", defaultValue: "committed_date", comment: "GitLab API key for commit committed date")
        case authoredDate = String(localized: "gitlab.commit.key.authored-date", defaultValue: "authored_date", comment: "GitLab API key for commit authored date")
        case parentIDs = String(localized: "gitlab.commit.key.parent-ids", defaultValue: "parent_ids", comment: "GitLab API key for commit parent IDs")
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
        case newPath = String(localized: "gitlab.commit-diff.key.new-path", defaultValue: "new_path", comment: "GitLab API key for commit diff new path")
        case oldPath = String(localized: "gitlab.commit-diff.key.old-path", defaultValue: "old_path", comment: "GitLab API key for commit diff old path")
        case aMode = String(localized: "gitlab.commit-diff.key.a-mode", defaultValue: "a_mode", comment: "GitLab API key for commit diff a mode")
        case bMode = String(localized: "gitlab.commit-diff.key.b-mode", defaultValue: "b_mode", comment: "GitLab API key for commit diff b mode")
        case newFile = String(localized: "gitlab.commit-diff.key.new-file", defaultValue: "new_file", comment: "GitLab API key for commit diff new file")
        case renamedFile = String(localized: "gitlab.commit-diff.key.renamed-file", defaultValue: "renamed_file", comment: "GitLab API key for commit diff renamed file")
        case deletedFile = String(localized: "gitlab.commit-diff.key.deleted-file", defaultValue: "deleted_file", comment: "GitLab API key for commit diff deleted file")
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
        case createdAt = String(localized: "gitlab.commit-status.key.created-at", defaultValue: "created_at", comment: "GitLab API key for commit status created date")
        case startedAt = String(localized: "gitlab.commit-status.key.started-at", defaultValue: "started_at", comment: "GitLab API key for commit status started date")
        case name
        case allowFailure = String(localized: "gitlab.commit-status.key.allow-failure", defaultValue: "allow_failure", comment: "GitLab API key for commit status allow failure")
        case author
        case statusDescription = String(localized: "gitlab.commit-status.key.description", defaultValue: "description", comment: "GitLab API key for commit status description")
        case sha
        case targetURL = String(localized: "gitlab.commit-status.key.target-url", defaultValue: "target_url", comment: "GitLab API key for commit status target URL")
        case finishedAt = String(localized: "gitlab.commit-status.key.finished-at", defaultValue: "finished_at", comment: "GitLab API key for commit status finished date")
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
