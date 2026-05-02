//
//  GitClient+CommitHistory.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import Foundation

extension GitClient {
    /// Gets the commit history log for the specified branch or file
    /// - Parameters:
    ///   - branchName: Name of the branch
    ///   - maxCount: Maximum amount of entries to get
    ///   - fileLocalPath: Optional path of file to get history for
    /// - Returns: Array of git commits
    func getCommitHistory(
        branchName: String? = nil,
        maxCount: Int? = nil,
        fileLocalPath: String? = nil,
        showMergeCommits: Bool = false
    ) async throws -> [GitCommit] {
        let branchString = branchName != nil ? String(format: String(localized: "git.log.branch.param", defaultValue: "\"%@\"", comment: "Git log branch parameter"), branchName ?? "") : ""
        let fileString = fileLocalPath != nil ? String(format: String(localized: "git.log.file.param", defaultValue: "\"%@\"", comment: "Git log file parameter"), fileLocalPath ?? "") : ""
        let countString = maxCount != nil ? String(format: String(localized: "git.log.count.param", defaultValue: "-n %d", comment: "Git log count parameter"), maxCount ?? 0) : ""

        let dateFormatter = DateFormatter()

        // Can't use `Locale.current`, since it'd give a nil date outside the US
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = String(localized: "git.log.date.format", defaultValue: "EEE, dd MMM yyyy HH:mm:ss Z", comment: "Git log date format")

        let noMergesFlag = String(localized: "git.log.no.merges.flag", defaultValue: "--no-merges", comment: "Git log no merges flag")
        let output = try await run(
            """
            log \(showMergeCommits ? "" : noMergesFlag) -z \
            --pretty=%h¦%H¦%s¦%aN¦%ae¦%cn¦%ce¦%aD¦%b¦%D¦ \
            \(countString) \(branchString) -- \(fileString)
            """.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        let remoteURL = try await getRemoteURL()

        let separator = String(localized: "git.log.separator", defaultValue: "¦", comment: "Git log field separator")
        let tagPrefix = String(localized: "git.log.tag.prefix", defaultValue: "tag:", comment: "Git log tag prefix")
        let commaSeparator = String(localized: "git.log.comma.separator", defaultValue: ",", comment: "Git log comma separator")
        let originHead = String(localized: "git.log.origin.head", defaultValue: "origin/HEAD", comment: "Git log origin HEAD marker")
        let headMarker = String(localized: "git.log.head.marker", defaultValue: "HEAD -> ", comment: "Git log HEAD marker")

        return output
            .split(separator: "\0")
            .map { line -> GitCommit in
                let parameters = String(line).components(separatedBy: separator)
                let infoRef = parameters[safe: 9]
                var refs: [String] = []
                var tag = ""
                if let infoRef = infoRef {
                    if infoRef.contains(tagPrefix) {
                        tag = infoRef.components(separatedBy: tagPrefix)[1].trimmingCharacters(in: .whitespaces)
                    } else {
                        refs = infoRef.split(separator: Character(commaSeparator)).compactMap {
                            var element = String($0)
                            if element.contains(originHead) { return nil }
                            if element.contains(headMarker) {
                                element = element.replacingOccurrences(of: headMarker, with: "")
                            }
                            return element.trimmingCharacters(in: .whitespaces)
                        }
                    }
                }

                return GitCommit(
                    hash: parameters[safe: 0] ?? "",
                    commitHash: parameters[safe: 1] ?? "",
                    message: parameters[safe: 2] ?? "",
                    author: parameters[safe: 3] ?? "",
                    authorEmail: parameters[safe: 4] ?? "",
                    committer: parameters[safe: 5] ?? "",
                    committerEmail: parameters[safe: 6] ?? "",
                    body: parameters[safe: 8] ?? "",
                    refs: refs,
                    tag: tag,
                    remoteURL: remoteURL,
                    date: dateFormatter.date(from: parameters[safe: 7] ?? "") ?? Date()
                )
            }
    }
}
