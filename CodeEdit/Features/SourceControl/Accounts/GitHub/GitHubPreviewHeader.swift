//
//  GitHubPreviewHeader.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

// TODO: DOCS (Nanashi Li)

/// Some APIs provide additional data for new (preview) APIs if a custom header is added to the request.
///
/// - Note: Preview APIs are subject to change.
enum GitHubPreviewHeader {
    /// The `Reactions` preview header provides reactions in `Comment`s.
    case reactions

    var header: GitHTTPHeader {
        switch self {
        case .reactions:
            return GitHTTPHeader(headerField: String(localized: "http.header.accept", defaultValue: "Accept", comment: "HTTP header name - technical constant, should not be localized"), value: String(localized: "mime.github-preview", defaultValue: "application/vnd.github.squirrel-girl-preview", comment: "GitHub API MIME type - technical constant, should not be localized"))
        }
    }
}
