//
//  GitClient+Push.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import Foundation

extension GitClient {
    /// Push changes to remote
    func pushToRemote(
        remote: String? = nil,
        branch: String? = nil,
        setUpstream: Bool? = false,
        force: Bool? = false,
        tags: Bool? = false
    ) async throws {
        var command = String(localized: "git.command.push", defaultValue: "push", comment: "Git command - technical constant, should not be localized")
        if let remote, let branch {
            if setUpstream == true {
                command += " --set-upstream"
            }
            if force == true {
                command += " --force"
            }
            if tags == true {
                command += " --tags"
            }
            command += " \(remote) \(branch)"
        }

        let output = try await self.run(command)

        if output.contains(String(localized: "git.status.rejected", defaultValue: "rejected", comment: "Git push status keyword - technical constant, should not be localized")) {
            throw GitClientError.outputError(output)
        }
    }
}
