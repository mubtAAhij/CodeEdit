//
//  GitClient+Branches.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import Foundation

extension GitClient {
    /// Get branches
    /// - Parameter remote: If passed, fetches branches for the specified remote
    /// - Returns: Array of branches
    func getBranches(remote: String? = nil) async throws -> [GitBranch] {
        var command = String(localized: "git.branch.command.list.format", defaultValue: "branch --format \"%(refname:short)|%(refname)|%(upstream:short) %(upstream:track)\"", comment: "Git command for listing branches with format")
        if remote != nil {
            command += " -r"
        } else {
            command += " -a"
        }

        return try await run(command)
            .components(separatedBy: "\n")
            .filter { $0 != "" && !$0.contains(String(localized: "git.branch.head.marker", defaultValue: "HEAD", comment: "Git HEAD marker for current branch reference")) && (remote == nil || $0.starts(with: String(format: String(localized: "git.branch.remote.prefix.format", defaultValue: "%@/", comment: "Format for remote branch prefix"), remote ?? ""))) }
            .compactMap { line in
                guard let branchPart = line.components(separatedBy: " ").first else { return nil }
                let branchComponents = branchPart.components(separatedBy: String(localized: "git.branch.separator.pipe", defaultValue: "|", comment: "Pipe separator for Git branch format output"))
                let name = branchComponents[0]
                let upstream = branchComponents[safe: 2]

                let trackInfoString = line
                    .dropFirst(branchPart.count)
                    .trimmingCharacters(in: .whitespacesWithoutNewlines)
                let trackInfo = parseBranchTrackInfo(from: trackInfoString)

                return GitBranch(
                    name: remote != nil ? extractBranchName(from: name, with: remote ?? "") : name,
                    longName: branchComponents[safe: 1] ?? name,
                    upstream: upstream?.isEmpty == true ? nil : upstream,
                    ahead: trackInfo.ahead,
                    behind: trackInfo.behind
                )
            }
    }

    /// Get current branch
    func getCurrentBranch() async throws -> GitBranch? {
        let branchName = try await run(String(localized: "git.branch.command.show.current", defaultValue: "branch --show-current", comment: "Git command to show current branch name")).trimmingCharacters(in: .whitespacesAndNewlines)
        let output = try await run(
            String(format: String(localized: "git.branch.command.for.each.ref.format", defaultValue: "for-each-ref --format=\"%(refname)|%(upstream:short) %(upstream:track)\" refs/heads/%@", comment: "Git command format for fetching branch reference info"), branchName)
        )
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let branchPart = output.components(separatedBy: " ").first else { return nil }
        let branchComponents = branchPart.components(separatedBy: String(localized: "git.branch.separator.pipe", defaultValue: "|", comment: "Pipe separator for Git branch format output"))
        let upstream = branchComponents[safe: 1]

        let trackInfoString = output
            .dropFirst(branchPart.count)
            .trimmingCharacters(in: .whitespacesWithoutNewlines)
        let trackInfo = parseBranchTrackInfo(from: trackInfoString)

        return .init(
            name: branchName,
            longName: branchComponents[0],
            upstream: upstream?.isEmpty == true ? nil : upstream,
            ahead: trackInfo.ahead,
            behind: trackInfo.behind
        )
    }

    /// Delete branch
    func deleteBranch(_ branch: GitBranch) async throws {
        if !branch.isLocal {
            return
        }

        _ = try await run(String(format: String(localized: "git.branch.command.delete.format", defaultValue: "branch -d %@", comment: "Git command format for deleting a branch"), branch.name))
    }

    /// Rename branch
    /// - Parameter from: Name of the branch to rename
    /// - Parameter to: New name for branch
    func renameBranch(oldName: String, newName: String) async throws {
        _ = try await run(String(format: String(localized: "git.branch.command.rename.format", defaultValue: "branch -m %@ %@", comment: "Git command format for renaming a branch"), oldName, newName))
    }

    /// Checkout branch
    /// - Parameter branch: Branch to checkout
    func checkoutBranch(_ branch: GitBranch, forceLocal: Bool = false, newName: String? = nil) async throws {
        var command = String(localized: "git.branch.command.checkout.prefix", defaultValue: "checkout ", comment: "Git checkout command prefix")

        let targetName = newName ?? branch.name

        if (branch.isRemote && !forceLocal) || newName != nil {
            let sourceBranch = branch.isRemote
                ? branch.longName.replacingOccurrences(of: String(localized: "git.branch.refs.remotes.prefix", defaultValue: "refs/remotes/", comment: "Git refs remotes path prefix"), with: "")
                : branch.name
            command += "-b \(targetName) \(sourceBranch)"
        } else {
            command += targetName
        }

        do {
            let output = try await run(command)
            if !output.contains(String(localized: "git.branch.checkout.switched.existing", defaultValue: "Switched to branch", comment: "Git output message when switching to existing branch")) && !output.contains(String(localized: "git.branch.checkout.switched.new", defaultValue: "Switched to a new branch", comment: "Git output message when switching to new branch")) {
                throw GitClientError.outputError(output)
            }
        } catch {
            // If branch is remote and command failed because branch already exists
            // try to switch to local branch
            if let error = error as? GitClientError,
               branch.isRemote,
               error.description.contains(String(localized: "git.branch.error.already.exists", defaultValue: "already exists", comment: "Git error message when branch already exists")) {
                try await checkoutBranch(branch, forceLocal: true)
            } else {
                logger.error(String(format: String(localized: "git.branch.error.checkout.failed.format", defaultValue: "Failed to checkout branch: %@", comment: "Error message format when branch checkout fails"), String(describing: error)))
            }
        }
    }

    private func parseBranchTrackInfo(from infoString: String) -> (ahead: Int, behind: Int) {
        let pattern = "\\[ahead (\\d+)(?:, behind (\\d+))?\\]|\\[behind (\\d+)\\]"
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            fatalError(String(localized: "git.branch.regex.pattern.error", defaultValue: "Invalid regular expression pattern", comment: "Fatal error message when regex pattern is invalid"))
        }
        var ahead = 0
        var behind = 0
        // Match the input string with the regular expression
        if let match = regex.firstMatch(
            in: infoString,
            options: [],
            range: NSRange(location: 0, length: infoString.utf16.count)
        ) {
            // Extract the captured groups
            if let aheadRange = Range(match.range(at: 1), in: infoString),
               let aheadValue = Int(infoString[aheadRange]) {
                ahead = aheadValue
            }
            if let behindRange = Range(match.range(at: 2), in: infoString),
               let behindValue = Int(infoString[behindRange]) {
                behind = behindValue
            }
            if let behindRange = Range(match.range(at: 3), in: infoString),
               let behindValue = Int(infoString[behindRange]) {
                behind = behindValue
            }
        }
        return (ahead, behind)
    }

    private func extractBranchName(from fullBranchName: String, with remoteName: String) -> String {
        // Ensure the fullBranchName starts with the remoteName followed by a slash
        let prefix = String(format: String(localized: "git.branch.remote.name.prefix.format", defaultValue: "%@/", comment: "Format for remote name prefix in branch name"), remoteName)
        if fullBranchName.hasPrefix(prefix) {
            // Remove the remoteName and the slash to get the branch name
            return String(fullBranchName.dropFirst(prefix.count))
        } else {
            // If the fullBranchName does not start with the expected remoteName, return it unchanged
            return fullBranchName
        }
    }

}
