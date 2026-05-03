//
//  GitBranch.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import Foundation

struct GitBranch: Hashable, Identifiable {
    let name: String
    let longName: String
    let upstream: String?
    let ahead: Int
    let behind: Int

    var id: String {
        longName
    }

    /// Is local branch
    var isLocal: Bool {
        return longName.hasPrefix(String(localized: "git.ref.heads", defaultValue: "refs/heads/", comment: "Git ref prefix for local branches - technical constant, should not be localized"))
    }

    /// Is remote branch
    var isRemote: Bool {
        return longName.hasPrefix(String(localized: "git.ref.remotes", defaultValue: "refs/remotes/", comment: "Git ref prefix for remote branches - technical constant, should not be localized"))
    }
}
