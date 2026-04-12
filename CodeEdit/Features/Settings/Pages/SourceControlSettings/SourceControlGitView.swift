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
    @State private var resolvedGitIgnorePath: String = "~/.gitignore_global"

    var body: some View {
        Group {
            Section {
                gitAuthorName
                gitEmail
            } header: {
                Text(String(localized: "source-control.git-configuration", defaultValue: "Git Configuration", comment: "Section header for Git configuration"))
                Text(String(localized: "source-control.git-configuration.description", defaultValue: """
                Applied globally to all repositories on your Mac. \
                [Learn more...](https://git-scm.com/docs/git-config)
                """, comment: "Description for Git configuration section"))
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
                Text(String(localized: "source-control.ignored-files", defaultValue: "Ignored Files", comment: "Section header for ignored files"))
                Text(String(localized: "source-control.ignored-files.description", defaultValue: """
                Patterns for files and folders that Git should ignore and not track. \
                Applied globally to all repositories on your Mac. \
                [Learn more...](https://git-scm.com/docs/gitignore)
                """, comment: "Description for ignored files section"))
            }
            Section {
                gitIgnoreEditor
            }
        }
        .onAppear {
            // Intentionally using an onAppear with a Task instead of just a .task modifier.
            // When we did this it was executing too often.
            Task {
                authorName = try await gitConfig.get(key: "user.name", global: true) ?? ""
                authorEmail = try await gitConfig.get(key: "user.email", global: true) ?? ""
                defaultBranch = try await gitConfig.get(key: "init.defaultBranch", global: true) ?? ""
                preferRebaseWhenPulling = try await gitConfig.get(key: "pull.rebase", global: true) ?? false
                try? await Task.sleep(for: .milliseconds(0))
                hasAppeared = true
            }
        }
    }
}

private extension SourceControlGitView {
    private var gitAuthorName: some View {
        TextField(String(localized: "source-control.author-name", defaultValue: "Author Name", comment: "Label for Git author name field"), text: $authorName)
            .onChange(of: authorName) { _, newValue in
                if hasAppeared {
                    Limiter.debounce(id: "authorNameDebouncer", duration: 0.5) {
                        Task {
                            await gitConfig.set(key: "user.name", value: newValue, global: true)
                        }
                    }
                }
            }
    }

    private var gitEmail: some View {
        TextField(String(localized: "source-control.author-email", defaultValue: "Author Email", comment: "Label for Git author email field"), text: $authorEmail)
            .onChange(of: authorEmail) { _, newValue in
                if hasAppeared {
                    Limiter.debounce(id: "authorEmailDebouncer", duration: 0.5) {
                        Task {
                            await gitConfig.set(key: "user.email", value: newValue, global: true)
                        }
                    }
                }
            }
    }

    private var defaultBranchName: some View {
        TextField(text: $defaultBranch) {
            Text(String(localized: "source-control.default-branch-name", defaultValue: "Default branch name", comment: "Label for default branch name field"))
            Text(String(localized: "source-control.default-branch-name.help", defaultValue: "Cannot contain spaces, backslashes, or other symbols", comment: "Help text for default branch name field"))
        }
        .onChange(of: defaultBranch) { _, newValue in
            if hasAppeared {
                Limiter.debounce(id: "defaultBranchDebouncer", duration: 0.5) {
                    Task {
                        await gitConfig.set(key: "init.defaultBranch", value: newValue, global: true)
                    }
                }
            }
        }
    }

    private var preferToRebaseWhenPulling: some View {
        Toggle(
            String(localized: "source-control.prefer-rebase-when-pulling", defaultValue: "Prefer to rebase when pulling", comment: "Toggle for preferring rebase when pulling"),
            isOn: $preferRebaseWhenPulling
        )
        .onChange(of: preferRebaseWhenPulling) { _, newValue in
            if hasAppeared {
                Limiter.debounce(id: "pullRebaseDebouncer", duration: 0.5) {
                    Task {
                        await gitConfig.set(key: "pull.rebase", value: newValue, global: true)
                    }
                }
            }
        }
    }

    private var showMergeCommitsInPerFileLog: some View {
        Toggle(
            String(localized: "source-control.show-merge-commits", defaultValue: "Show merge commits in per-file log", comment: "Toggle for showing merge commits in per-file log"),
            isOn: $git.showMergeCommitsPerFileLog
        )
    }

    private var gitConfigEditor: some View {
        HStack {
            Text(String(localized: "source-control.git-config-location", defaultValue: "Git configuration is stored in \"~/.gitconfig\".", comment: "Text showing where Git config is stored"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "source-control.open-in-editor", defaultValue: "Open in Editor...", comment: "Button to open file in editor"), action: openGitConfigFile)
        }
        .frame(maxWidth: .infinity)
    }

    private var gitIgnoreEditor: some View {
        HStack {
            Text(String(format: String(localized: "source-control.gitignore-location", defaultValue: "Ignored file patterns are stored in \"%@\".", comment: "Text showing where gitignore patterns are stored"), resolvedGitIgnorePath))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "source-control.open-in-editor", defaultValue: "Open in Editor...", comment: "Button to open file in editor"), action: openGitIgnoreFile)
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
                key: "core.excludesfile",
                global: true
            ), !excludesfile.isEmpty {
                if excludesfile.starts(with: "~/") {
                    let relativePath = String(excludesfile.dropFirst(2))
                    return FileManager.default.homeDirectoryForCurrentUser.appending(path: relativePath)
                } else if excludesfile.starts(with: "/") {
                    return URL(fileURLWithPath: excludesfile)
                } else {
                    return FileManager.default.homeDirectoryForCurrentUser.appending(path: excludesfile)
                }
            } else {
                let defaultURL = FileManager.default.homeDirectoryForCurrentUser.appending(
                    path: ".gitignore_global"
                )
                await gitConfig.set(key: "core.excludesfile", value: "~/\(defaultURL.lastPathComponent)", global: true)
                return defaultURL
            }
        }
    }

    private func gitIgnorePath() async -> String {
        do {
            let url = try await gitIgnoreURL
            return url.path.replacingOccurrences(of: FileManager.default.homeDirectoryForCurrentUser.path, with: "~")
        } catch {
            return "~/.gitignore_global"
        }
    }

    private func openGitConfigFile() {
        let fileURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: ".gitconfig")

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }

        NSDocumentController.shared.openDocument(
            withContentsOf: fileURL,
            display: true
        ) { _, _, error in
            if let error = error {
                print("Failed to open document: \(error.localizedDescription)")
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
                print("Failed to open document: \(error.localizedDescription)")
            }
        }
    }
}
