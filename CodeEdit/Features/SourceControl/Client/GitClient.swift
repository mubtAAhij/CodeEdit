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
            case let .outputError(string): string
            case .notGitRepository: String(localized: "source-control.git-client.error.not-a-git-repository", defaultValue: "Not a git repository", comment: "Error message when current directory is not a git repository")
            case .failedToDecodeURL: String(localized: "source-control.git-client.error.failed-to-decode-url", defaultValue: "Failed to decode URL", comment: "Error message when a URL cannot be decoded in git client")
            case .noRemoteConfigured: String(localized: "source-control.git-client.error.no-remote-configured", defaultValue: "No remote configured", comment: "Error message when repository has no configured remote")
            case .statusParseEarlyEnd: String(localized: "source-control.git-client.error.invalid-status-end-of-string", defaultValue: "Invalid status, found end of string too early", comment: "Error message when parsing git status encounters unexpected end of string")
            case let .invalidStatus(char): "Invalid status received: \(char)"
            case let .statusInvalidChangeType(char): "Status invalid change type: \(char)"
            }
        }
    }

    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "GitClient")

    let directoryURL: URL
    let shellClient: ShellClient

    private let configClient: GitConfigClient

    init(directoryURL: URL, shellClient: ShellClient) {
        self.directoryURL = directoryURL
        self.shellClient = shellClient
        configClient = GitConfigClient(projectURL: directoryURL, shellClient: shellClient)
    }

    func getConfig<T: GitConfigRepresentable>(key: String) async throws -> T? {
        return try await configClient.get(key: key, global: false)
    }

    func setConfig<T: GitConfigRepresentable>(key: String, value: T) async {
        await configClient.set(key: key, value: value, global: false)
    }

    /// Runs a git command, it will prepend the command with `cd <directoryURL>;git`,
    /// If you need to run "git checkout", pass "checkout" as the command parameter
    func run(_ command: String) async throws -> String {
        let output = try shellClient.run(generateCommand(command))
        return try processCommonErrors(output)
    }

    typealias LiveCommandStream = AsyncThrowingMapSequence<AsyncThrowingStream<String, Error>, String>

    /// Runs a git command in same way as `run`, but returns a async stream of the output
    func runLive(_ command: String) -> LiveCommandStream {
        return runLive(customCommand: generateCommand(command))
    }

    /// Here you can run a custom command, this is needed for git clone
    func runLive(customCommand: String) -> LiveCommandStream {
        return shellClient
            .runAsync(customCommand)
            .map { output in
                try self.processCommonErrors(output)
            }
    }

    private func generateCommand(_ command: String) -> String {
        "cd \(directoryURL.relativePath.escapedDirectory());git \(command)"
    }

    private func processCommonErrors(_ output: String) throws -> String {
        if output.contains("fatal: not a git repository") {
            throw GitClientError.notGitRepository
        }

        if output.contains("fatal: No remote configured") {
            throw GitClientError.noRemoteConfigured
        }

        if output.hasPrefix("fatal:") {
            throw GitClientError.outputError(output)
        }

        return output
    }
}
