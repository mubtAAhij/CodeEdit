//
//  GitClient+Commit.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import Foundation
import RegexBuilder

extension GitClient {
    /// Commit files
    /// - Parameters:
    ///   - message: Commit message
    func commit(message: String, details: String?) async throws {
        let quote = String(localized: "git.commit.quote", defaultValue: "\"", comment: "Git commit quote character")
        let escapedQuote = String(localized: "git.commit.escaped.quote", defaultValue: "\\\"", comment: "Git commit escaped quote character")
        let message = message.replacingOccurrences(of: quote, with: escapedQuote)
        let command: String

        if let msgDetails = details {
            command = String(format: String(localized: "git.commit.command.with.details", defaultValue: "commit --message=\"%@\"", comment: "Git commit command with details"), message + (msgDetails.isEmpty ? "" : ("\n\n" + msgDetails)))
        } else {
            command = String(format: String(localized: "git.commit.command", defaultValue: "commit --message=\"%@\"", comment: "Git commit command"), message)
        }

        _ = try await run(command)
    }

    /// Add file to git
    /// - Parameter file: File to add
    func add(_ files: [URL]) async throws {
        let quotedPaths = files.map { String(format: String(localized: "git.file.path.quoted", defaultValue: "'%@'", comment: "Git file path quoted"), $0.path(percentEncoded: false)) }.joined(separator: " ")
        let command = String(format: String(localized: "git.add.command", defaultValue: "add %@", comment: "Git add command"), quotedPaths)
        let output = try await run(command)
        print(output)
    }

    /// Add file to git
    /// - Parameter file: File to add
    func reset(_ files: [URL]) async throws {
        let quotedPaths = files.map { String(format: String(localized: "git.file.path.quoted", defaultValue: "'%@'", comment: "Git file path quoted"), $0.path(percentEncoded: false)) }.joined(separator: " ")
        let command = String(format: String(localized: "git.reset.command", defaultValue: "reset %@", comment: "Git reset command"), quotedPaths)
        _ = try await run(command)
    }

    /// Returns tuple of unsynced commits both ahead and behind
    func numberOfUnsyncedCommits() async throws -> (ahead: Int, behind: Int) {
        let output = try await run(String(localized: "git.status.command", defaultValue: "status -sb --porcelain=v2", comment: "Git status command")).trimmingCharacters(in: .whitespacesAndNewlines)
        return try parseUnsyncedCommitsOutput(from: output)
    }

    func getCommitChangedFiles(commitSHA: String) async throws -> [GitChangedFile] {
        do {
            let output = try await run(String(format: String(localized: "git.diff.tree.command", defaultValue: "diff-tree --no-commit-id --name-status -r %@", comment: "Git diff-tree command"), commitSHA))
            let data = output
                .trimmingCharacters(in: .newlines)
                .components(separatedBy: "\n")
            return try data.compactMap { line -> GitChangedFile? in
                let components = line.split(separator: "\t")
                guard components.count == 2 else { return nil }
                let changeType = String(components[0])
                let pathName = String(components[1])

                guard let url = URL(string: pathName ) else {
                    throw GitClientError.failedToDecodeURL
                }

                let gitType: GitStatus? = .init(rawValue: changeType)
                let fullLink = self.directoryURL.appending(path: url.relativePath)

                return GitChangedFile(
                    status: gitType ?? .none,
                    stagedStatus: .none,
                    fileURL: fullLink,
                    originalFilename: nil
                )
            }
        } catch {
            print(String(format: String(localized: "git.error.message", defaultValue: "Error: %@", comment: "Git error message"), String(describing: error)))
            return []
        }
    }

    private func parseUnsyncedCommitsOutput(from string: String) throws -> (ahead: Int, behind: Int) {
        let components = string.components(separatedBy: .newlines)
        let branchPrefix = String(localized: "git.branch.ab.prefix", defaultValue: "# branch.ab", comment: "Git branch ab prefix")
        guard var abLine = components.first(where: { $0.starts(with: branchPrefix) }) else {
            // We're using --porcelain, this shouldn't happen
            return (ahead: 0, behind: 0)
        }
        let branchPrefixWithSpace = String(localized: "git.branch.ab.prefix.with.space", defaultValue: "# branch.ab ", comment: "Git branch ab prefix with space")
        abLine = String(abLine.dropFirst(branchPrefixWithSpace.count))
        let regex = Regex {
            One("+")
            Capture {
                OneOrMore(.digit)
            } transform: { Int($0) }
            One(String(localized: "git.branch.ab.separator", defaultValue: " -", comment: "Git branch ab separator"))
            Capture {
                OneOrMore(.digit)
            } transform: { Int($0) }
        }
        guard let match = try regex.firstMatch(in: abLine),
              let ahead = match.output.1,
              let behind = match.output.2 else {
            return (ahead: 0, behind: 0)
        }
        return (ahead: ahead, behind: behind)
    }
}
