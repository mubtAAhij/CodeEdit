//
//  SourceControlGitView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct SourceControlGitView: View {
    @AppSettings(\.sourceControl.git)
    var git

    let gitConfig = GitConfigClient(shellClient: currentWorld.shellClient)

    @State private var authorName: String = ""
    @State private var authorEmail: String = ""
    @State private var defaultBranch: String = ""
    @State private var preferRebaseWhenPulling: Bool = false
    @State private var hasAppeared: Bool = false
    @State private var resolvedGitIgnorePath: String = String(localized: "source-control.git.default-gitignore-path", defaultValue: "~/.gitignore_global", comment: "Default path to global git ignore file")

    var body: some View {
        Group {
            Section {
                gitAuthorName
                gitEmail
            } header: {
                Text(String(localized: "source-control.git.configuration-title", defaultValue: "Git Configuration", comment: "Title for git configuration section"))
                Text(String(localized: "source-control.git.configuration-description", defaultValue: "Applied globally to all repositories on your Mac. [Learn more...](https://git-scm.com/docs/git-config)", comment: "Description for git configuration section"))
            }
            Section {
                defaultBranchName
                preferToRebaseWhenPulling
                showMergeCommitsInPerFileLog
            }
            Section {
                gitConfigEditor
            }
            Section {
                IgnoredFilesListView()
            } header: {
                Text(String(localized: "source-control.git.ignored-files-title", defaultValue: "Ignored Files", comment: "Title for ignored files section"))
                Text(String(localized: "source-control.git.ignored-files-description", defaultValue: "Patterns for files and folders that Git should ignore and not track. Applied globally to all repositories on your Mac. [Learn more...](https://git-scm.com/docs/gitignore)", comment: "Description for ignored files section"))
            }
            Section {
                gitIgnoreEditor
            }
        }
        .onAppear {
            // Intentionally using an onAppear with a Task instead of just a .task modifier.
            // When we did this it was executing too often.
            Task {
                authorName = try await gitConfig.get(key: String(localized: "source-control.git.config-key.user-name", defaultValue: "user.name", comment: "Git config key for user name"), global: true) ?? ""
                authorEmail = try await gitConfig.get(key: String(localized: "source-control.git.config-key.user-email", defaultValue: "user.email", comment: "Git config key for user email"), global: true) ?? ""
                defaultBranch = try await gitConfig.get(key: String(localized: "source-control.git.config-key.init-default-branch", defaultValue: "init.defaultBranch", comment: "Git config key for init default branch"), global: true) ?? ""
                preferRebaseWhenPulling = try await gitConfig.get(key: String(localized: "source-control.git.config-key.pull-rebase", defaultValue: "pull.rebase", comment: "Git config key for pull rebase"), global: true) ?? false
                try? await Task.sleep(for: .milliseconds(0))
                hasAppeared = true
            }
        }
    }
}

private extension SourceControlGitView {
    private var gitAuthorName: some View {
        TextField(String(localized: "source-control.git.author-name", defaultValue: "Author Name", comment: "Label for git author name field"), text: $authorName)
            .onChange(of: authorName) { _, newValue in
                if hasAppeared {
                    Limiter.debounce(id: String(localized: "source-control.git.debouncer.author-name", defaultValue: "authorNameDebouncer", comment: "Debouncer ID for author name field"), duration: 0.5) {
                        Task {
                            await gitConfig.set(key: String(localized: "source-control.git.config-key.user-name", defaultValue: "user.name", comment: "Git config key for user name"), value: newValue, global: true)
                        }
                    }
                }
            }
    }

    private var gitEmail: some View {
        TextField(String(localized: "source-control.git.author-email", defaultValue: "Author Email", comment: "Label for git author email field"), text: $authorEmail)
            .onChange(of: authorEmail) { _, newValue in
                if hasAppeared {
                    Limiter.debounce(id: String(localized: "source-control.git.debouncer.author-email", defaultValue: "authorEmailDebouncer", comment: "Debouncer ID for author email field"), duration: 0.5) {
                        Task {
                            await gitConfig.set(key: String(localized: "source-control.git.config-key.user-email", defaultValue: "user.email", comment: "Git config key for user email"), value: newValue, global: true)
                        }
                    }
                }
            }
    }

    private var defaultBranchName: some View {
        TextField(text: $defaultBranch) {
            Text(String(localized: "source-control.git.default-branch-name", defaultValue: "Default branch name", comment: "Label for default branch name field"))
            Text(String(localized: "source-control.git.default-branch-name-hint", defaultValue: "Cannot contain spaces, backslashes, or other symbols", comment: "Hint for default branch name field"))
        }
        .onChange(of: defaultBranch) { _, newValue in
            if hasAppeared {
                Limiter.debounce(id: String(localized: "source-control.git.debouncer.default-branch", defaultValue: "defaultBranchDebouncer", comment: "Debouncer ID for default branch field"), duration: 0.5) {
                    Task {
                        await gitConfig.set(key: String(localized: "source-control.git.config-key.init-default-branch", defaultValue: "init.defaultBranch", comment: "Git config key for init default branch"), value: newValue, global: true)
                    }
                }
            }
        }
    }

    private var preferToRebaseWhenPulling: some View {
        Toggle(
            String(localized: "source-control.git.prefer-rebase-when-pulling", defaultValue: "Prefer to rebase when pulling", comment: "Label for prefer rebase when pulling toggle"),
            isOn: $preferRebaseWhenPulling
        )
        .onChange(of: preferRebaseWhenPulling) { _, newValue in
            if hasAppeared {
                Limiter.debounce(id: String(localized: "source-control.git.debouncer.pull-rebase", defaultValue: "pullRebaseDebouncer", comment: "Debouncer ID for pull rebase toggle"), duration: 0.5) {
                    Task {
                        await gitConfig.set(key: String(localized: "source-control.git.config-key.pull-rebase", defaultValue: "pull.rebase", comment: "Git config key for pull rebase"), value: newValue, global: true)
                    }
                }
            }
        }
    }

    private var showMergeCommitsInPerFileLog: some View {
        Toggle(
            String(localized: "source-control.git.show-merge-commits-in-per-file-log", defaultValue: "Show merge commits in per-file log", comment: "Label for show merge commits in per-file log toggle"),
            isOn: $git.showMergeCommitsPerFileLog
        )
    }

    private var gitConfigEditor: some View {
        HStack {
            Text(String(localized: "source-control.git.config-editor-description", defaultValue: "Git configuration is stored in \"~/.gitconfig\".", comment: "Description for git config file location"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "source-control.git.open-in-editor", defaultValue: "Open in Editor...", comment: "Button to open file in editor"), action: openGitConfigFile)
        }
        .frame(maxWidth: .infinity)
    }

    private var gitIgnoreEditor: some View {
        HStack {
            Text(String(format: String(localized: "source-control.git.ignore-editor-description", defaultValue: "Ignored file patterns are stored in \"%@\".", comment: "Description for git ignore file location"), resolvedGitIgnorePath))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "source-control.git.open-in-editor", defaultValue: "Open in Editor...", comment: "Button to open file in editor"), action: openGitIgnoreFile)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                resolvedGitIgnorePath = await gitIgnorePath()
            }
        }
    }

    private var gitIgnoreURL: URL {
        get async throws {
            if let excludesfile: String = try await gitConfig.get(
                key: String(localized: "source-control.git.config-key.core-excludesfile", defaultValue: "core.excludesfile", comment: "Git config key for core excludesfile"),
                global: true
            ), !excludesfile.isEmpty {
                if excludesfile.starts(with: String(localized: "source-control.git.path-prefix.tilde-slash", defaultValue: "~/", comment: "Path prefix for home directory")) {
                    let relativePath = String(excludesfile.dropFirst(2))
                    return FileManager.default.homeDirectoryForCurrentUser.appending(path: relativePath)
                } else if excludesfile.starts(with: String(localized: "source-control.git.path-prefix.slash", defaultValue: "/", comment: "Path prefix for absolute path")) {
                    return URL(fileURLWithPath: excludesfile)
                } else {
                    return FileManager.default.homeDirectoryForCurrentUser.appending(path: excludesfile)
                }
            } else {
                let defaultURL = FileManager.default.homeDirectoryForCurrentUser.appending(
                    path: String(localized: "source-control.git.default-gitignore-filename", defaultValue: ".gitignore_global", comment: "Default gitignore filename")
                )
                await gitConfig.set(key: String(localized: "source-control.git.config-key.core-excludesfile", defaultValue: "core.excludesfile", comment: "Git config key for core excludesfile"), value: String(format: String(localized: "source-control.git.default-excludesfile-value", defaultValue: "~/%@", comment: "Default value for core.excludesfile"), defaultURL.lastPathComponent), global: true)
                return defaultURL
            }
        }
    }

    private func gitIgnorePath() async -> String {
        do {
            let url = try await gitIgnoreURL
            return url.path.replacingOccurrences(of: FileManager.default.homeDirectoryForCurrentUser.path, with: String(localized: "source-control.git.path-prefix.tilde", defaultValue: "~", comment: "Tilde for home directory path"))
        } catch {
            return String(localized: "source-control.git.default-gitignore-path", defaultValue: "~/.gitignore_global", comment: "Default path to global git ignore file")
        }
    }

    private func openGitConfigFile() {
        let fileURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: String(localized: "source-control.git.gitconfig-filename", defaultValue: ".gitconfig", comment: "Gitconfig filename"))

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }

        NSDocumentController.shared.openDocument(
            withContentsOf: fileURL,
            display: true
        ) { _, _, error in
            if let error = error {
                print(String(format: String(localized: "source-control.git.failed-to-open-document", defaultValue: "Failed to open document: %@", comment: "Error message for failed document open"), error.localizedDescription))
            }
        }
    }

    private func openGitIgnoreFile() {
        Task {
            do {
                let fileURL = try await gitIgnoreURL

                // Ensure the file exists
                if !FileManager.default.fileExists(atPath: fileURL.path) {
                    FileManager.default.createFile(atPath: fileURL.path, contents: nil)
                }

                // Open the file in the editor
                try await NSDocumentController.shared.openDocument(withContentsOf: fileURL, display: true)
            } catch {
                print(String(format: String(localized: "source-control.git.failed-to-open-document", defaultValue: "Failed to open document: %@", comment: "Error message for failed document open"), error.localizedDescription))
            }
        }
    }
}
