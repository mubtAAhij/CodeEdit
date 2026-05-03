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
        let command = String(localized: "git.command.fetch", defaultValue: "fetch", comment: "Git command - technical constant, should not be localized")

        _ = try await self.run(command)
    }
}
