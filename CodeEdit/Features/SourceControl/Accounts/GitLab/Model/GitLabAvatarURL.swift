//
//  GitLabAvatarURL.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

class GitLabAvatarURL: Codable {
    var url: URL?

    init(_ json: [String: AnyObject]) {
        if let urlString = json[String(localized: "gitlab.api.url-key", defaultValue: "url", comment: "GitLab API JSON key - technical constant, should not be localized")] as? String, let urlFromString = URL(string: urlString) {
            url = urlFromString
        }
    }
}
