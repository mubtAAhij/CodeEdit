//
//  GitClient.swift
//  CodeEdit
//
//  Created by Matthijs Eikelenboom on 26/11/2022.
//

import Combine
import Foundation
import OSLog

class GitClient {
    enum GitClientError: Error {
        case outputError(String)
        case notGitRepository
        case failedToDecodeURL
        case noRemoteConfigured
        // Status parsing
        case statusParseEarlyEnd
        case invalidStatus(_ char: Character)
        case statusInvalidChangeType(_ type: Character)

        var description: String {
            switch self {
            case .outputError(let string): string
            case .notGitRepository: String(localized: "git-client.error.not-repository", defaultValue: "Not a git repository", comment: "Error message when directory is not a git repository")
            case .failedToDecodeURL: String(localized: "git-client.error.decode-url", defaultValue: "Failed to decode URL", comment: "Error message when URL decoding fails")
            case .noRemoteConfigured: String(localized: "git-client.error.no-remote", defaultValue: "No remote configured", comment: "Error message when no remote is configured")
            case .statusParseEarlyEnd: String(localized: "git-client.error.status-early-end", defaultValue: "Invalid status, found end of string too early", comment: "Error message when status parsing ends prematurely")
            case let .invalidStatus(char): String(format: String(localized: "git-client.error.invalid-status", defaultValue: "Invalid status received: %@", comment: "Error message when invalid status character is received"), String(char))
            case let .statusInvalidChangeType(char): String(format: String(localized: "git-client.error.invalid-change-type", defaultValue: "Status invalid change type: %@", comment: "Error message when invalid change type character is received"), String(char))
            }
        }
    }

    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: String(localized: "git-client.logger-category", defaultValue: "GitClient", comment: "Logger category for Git client operations"))

    internal let directoryURL: URL
    internal let shellClient: ShellClient

    private let configClient: GitConfigClient

    init(directoryURL: URL, shellClient: ShellClient) {
        self.directoryURL = directoryURL
        self.shellClient = shellClient
        self.configClient = GitConfigClient(projectURL: directoryURL, shellClient: shellClient)
    }

    func getConfig<T: GitConfigRepresentable>(key: String) async throws -> T? {
        return try await configClient.get(key: key, global: false)
    }

    func setConfig<T: GitConfigRepresentable>(key: String, value: T) async {
        await configClient.set(key: key, value: value, global: false)
    }

    /// Runs a git command, it will prepend the command with `cd <directoryURL>;git`,
    /// If you need to run "git checkout", pass "checkout" as the command parameter
    internal func run(_ command: String) async throws -> String {
        let output = try shellClient.run(generateCommand(command))
        return try processCommonErrors(output)
    }

    internal typealias LiveCommandStream = AsyncThrowingMapSequence<AsyncThrowingStream<String, Error>, String>

    /// Runs a git command in same way as `run`, but returns a async stream of the output
    internal func runLive(_ command: String) -> LiveCommandStream {
        return runLive(customCommand: generateCommand(command))
    }

    /// Here you can run a custom command, this is needed for git clone
    internal func runLive(customCommand: String) -> LiveCommandStream {
        return shellClient
            .runAsync(customCommand)
            .map { output in
                return try self.processCommonErrors(output)
            }
    }

    private func generateCommand(_ command: String) -> String {
        String(format: String(localized: "git-client.command-template", defaultValue: "cd %@;git %@", comment: "Shell command template for running git commands"), directoryURL.relativePath.escapedDirectory(), command)
    }

    private func processCommonErrors(_ output: String) throws -> String {
        if output.contains(String(localized: "git-client.error-matcher.not-repository", defaultValue: "fatal: not a git repository", comment: "Git error message matcher for non-repository directories")) {
            throw GitClientError.notGitRepository
        }

        if output.contains(String(localized: "git-client.error-matcher.no-remote", defaultValue: "fatal: No remote configured", comment: "Git error message matcher for missing remote configuration")) {
            throw GitClientError.noRemoteConfigured
        }

        if output.hasPrefix(String(localized: "git-client.error-matcher.fatal-prefix", defaultValue: "fatal:", comment: "Git error message prefix matcher for fatal errors")) {
            throw GitClientError.outputError(output)
        }

        return output
    }
}
