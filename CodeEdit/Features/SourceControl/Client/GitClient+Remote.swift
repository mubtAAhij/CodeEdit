//
//  GitClient+Remote.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/17/23.
//

import Foundation

extension GitClient {
    /// Gets all remotes
    /// - Parameter name: Name for remote
    /// - Parameter location: URL string for remote location
    func getRemotes() async throws -> [GitRemote] {
        let command = String(localized: "swift.preflight.literal.414243", defaultValue: "remote -v", comment: "")
        let output = try await run(command)
        let remotes = parseGitRemotes(from: output)

        return remotes
    }

    /// Add existing remote to local git
    /// - Parameter name: Name for remote
    /// - Parameter location: URL string for remote location
    func addRemote(name: String, location: String) async throws {
        _ = try await run("remote add \(name) \(location)")
    }

    /// Remove remote from local git
    /// - Parameter name: Name for remote to remove
    func removeRemote(name: String) async throws {
        _ = try await run("remote rm \(name)")
    }

    /// Get the URL of the remote
    /// > Note: If a git repository has multiple remotes, by default the `origin` remote
    /// > will be used, unless there’s an upstream branch configured for the current branch.
    /// > (Reference: https://git-scm.com/docs/git-ls-remote, https://git-scm.com/docs/git-fetch)
    /// - Returns: A URL if a remote is configured, nil otherwise
    /// - Throws: `GitClientError.outputError` if the underlying git command fails unexpectedly
    func getRemoteURL() async throws -> URL? {
        do {
            let remote = try await run(String(localized: "swift.preflight.literal.414246", defaultValue: "ls-remote --get-url", comment: ""))
            return URL(string: remote.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch GitClientError.noRemoteConfigured {
            return nil
        } catch {
            throw error
        }
    }
}

func parseGitRemotes(from output: String) -> [GitRemote] {
    var remotes: [String: (fetch: String?, push: String?)] = [:]

    output.split(separator: "\n").forEach { line in
        let components = line.split { $0 == " " || $0 == "\t" }
        guard components.count == 3 else { return }

        let name = String(components[0])
        let location = String(components[1])
        let type = components[2].contains(String(localized: "swift.preflight.literal.414247", defaultValue: "(fetch)", comment: "")) ? String(localized: "swift.preflight.literal.414248", defaultValue: "fetch", comment: "") : String(localized: "swift.preflight.literal.414249", defaultValue: "push", comment: "")

        if var remote = remotes[name] {
            if type == String(localized: "swift.preflight.literal.414250", defaultValue: "fetch", comment: "") {
                remote.fetch = location
            } else {
                remote.push = location
            }
            remotes[name] = remote
        } else {
            if type == String(localized: "swift.preflight.literal.414251", defaultValue: "fetch", comment: "") {
                remotes[name] = (fetch: location, push: nil)
            } else {
                remotes[name] = (fetch: nil, push: location)
            }
        }
    }

    return remotes.compactMap { name, locations in
        if let fetchLocation = locations.fetch, let pushLocation = locations.push {
            return GitRemote(name: name, pushLocation: pushLocation, fetchLocation: fetchLocation)
        }
        return nil
    }
}
