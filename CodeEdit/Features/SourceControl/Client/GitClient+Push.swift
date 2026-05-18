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
        var command = String(localized: "swift.preflight.literal.437940", defaultValue: "push", comment: "")
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

        if output.contains(String(localized: "swift.preflight.literal.437945", defaultValue: "rejected", comment: "")) {
            throw GitClientError.outputError(output)
        }
    }
}
