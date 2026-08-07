//
//  GitClient+Fetch.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/18/23.
//

import Foundation

extension GitClient {
    /// Fetch changes to remote
    func fetchFromRemote() async throws {
        let command = String(localized: "source-control.git-client.command.fetch", defaultValue: "fetch", comment: "Git command name for fetching remote changes")

        _ = try await self.run(command)
    }
}
