//
//  GitCommit.swift
//  CodeEditModules/Git
//
//  Created by Marco Carnevali on 27/03/22.
//

import Foundation.NSDate

/// Model class to help map commit history log data
struct GitCommit: Equatable, Hashable, Identifiable {
    var id = UUID()
    let hash: String
    let commitHash: String
    let message: String
    let author: String
    let authorEmail: String
    let committer: String
    let committerEmail: String
    let body: String
    let refs: [String]
    let tag: String
    let remoteURL: URL?
    let date: Date

    var commitBaseURL: URL? {
        if let remoteURL {
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.github.slug", defaultValue: "github", comment: "GitHub provider slug for URL matching")) {
                return parsedRemoteUrl(domain: String(localized: "git.commit.provider.github.domain", defaultValue: "https://github.com", comment: "GitHub domain URL for commit links"), remote: remoteURL)
            }
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.bitbucket.slug", defaultValue: "bitbucket", comment: "Bitbucket provider slug for URL matching")) {
                return parsedRemoteUrl(domain: String(localized: "git.commit.provider.bitbucket.domain", defaultValue: "https://bitbucket.org", comment: "Bitbucket domain URL for commit links"), remote: remoteURL)
            }
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.gitlab.slug", defaultValue: "gitlab", comment: "GitLab provider slug for URL matching")) {
                return parsedRemoteUrl(domain: String(localized: "git.commit.provider.gitlab.domain", defaultValue: "https://gitlab.com", comment: "GitLab domain URL for commit links"), remote: remoteURL)
            }
            // TODO: Implement other git clients other than github, bitbucket here
        }
        return nil
    }

    private func parsedRemoteUrl(domain: String, remote: URL) -> URL {
        // There are 2 types of remotes - https and ssh. While https has URL in its name, ssh doesn't.
        // Following code takes remote name in format profileName/repoName and prepends according domain
        var formattedRemote = remote
        if formattedRemote.absoluteString.starts(with: String(localized: "git.commit.remote.ssh.prefix", defaultValue: "git@", comment: "SSH remote URL prefix for Git repositories")) {
            let parts = formattedRemote.absoluteString.components(separatedBy: String(localized: "git.commit.remote.ssh.separator", defaultValue: ":", comment: "Separator character in SSH remote URLs"))
            formattedRemote = URL.init(fileURLWithPath: String(format: String(localized: "git.commit.remote.url.format", defaultValue: "%@/%@", comment: "Format for constructing remote URL from domain and path"), domain, parts[parts.count - 1]))
        }

        return formattedRemote.deletingPathExtension().appending(path: String(localized: "git.commit.path.commit", defaultValue: "commit", comment: "URL path component for commit view"))
    }

    var remoteString: String {
        if let remoteURL {
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.github.slug", defaultValue: "github", comment: "GitHub provider slug for URL matching")) {
                return String(localized: "git.commit.provider.github.name", defaultValue: "GitHub", comment: "Display name for GitHub provider")
            }
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.bitbucket.slug", defaultValue: "bitbucket", comment: "Bitbucket provider slug for URL matching")) {
                return String(localized: "git.commit.provider.bitbucket.name", defaultValue: "BitBucket", comment: "Display name for Bitbucket provider")
            }
            if remoteURL.absoluteString.contains(String(localized: "git.commit.provider.gitlab.slug", defaultValue: "gitlab", comment: "GitLab provider slug for URL matching")) {
                return String(localized: "git.commit.provider.gitlab.name", defaultValue: "GitLab", comment: "Display name for GitLab provider")
            }
        }
        return String(localized: "git.commit.provider.remote.name", defaultValue: "Remote", comment: "Generic display name for remote Git provider")
    }
}
