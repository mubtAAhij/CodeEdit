//
//  GitClient+Pull.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/18/23.
//

import Foundation

extension GitClient {
    /// Pull changes from remote
    func pullFromRemote(remote: String? = nil, branch: String? = nil, rebase: Bool = false) async throws {
        let rebaseFlag = rebase ? String(localized: "git.pull.flag.rebase", defaultValue: "--rebase", comment: "Git pull rebase flag") : String(localized: "git.pull.flag.no_rebase", defaultValue: "--no-rebase", comment: "Git pull no-rebase flag")
        var command = String(format: String(localized: "git.pull.command", defaultValue: "pull %@", comment: "Git pull command with flags"), rebaseFlag)

        if let remote = remote, let branch = branch {
            command += " \(remote) \(branch)"
        }

        _ = try await self.run(command)
    }
}
