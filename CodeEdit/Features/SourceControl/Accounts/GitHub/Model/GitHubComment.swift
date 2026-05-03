//
//  GitHubComment.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

struct GitHubComment: Codable {
    let id: Int
    let url: URL
    let htmlURL: URL
    let body: String
    let user: GitHubUser
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, url, body, user
        case htmlURL = String(localized: "github.api.codingkey.html_url", defaultValue: "html_url", comment: "CodingKey for GitHub API JSON field - technical constant, not user-visible")
        case createdAt = String(localized: "github.api.codingkey.created_at", defaultValue: "created_at", comment: "CodingKey for GitHub API JSON field - technical constant, not user-visible")
        case updatedAt = String(localized: "github.api.codingkey.updated_at", defaultValue: "updated_at", comment: "CodingKey for GitHub API JSON field - technical constant, not user-visible")
    }
}
