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
        _ = try await self.run("fetch")
    }
}
