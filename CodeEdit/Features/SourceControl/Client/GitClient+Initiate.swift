//
//  GitClient+Initiate.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/16/23.
//

import Foundation

extension GitClient {
    /// Initiate Git repository
    func initiate() async throws {
        _ = try await run(String(localized: "source-control.git-client.command.init", defaultValue: "init", comment: "Git command name for repository initialization"))
    }
}
