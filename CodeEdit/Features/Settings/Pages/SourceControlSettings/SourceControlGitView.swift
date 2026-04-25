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
                Text(String(localized: "settings.source-control.git.config-header", defaultValue: "Git Configuration", comment: "Git configuration section header"))
                Text(String(localized: "settings.source-control.git.config-description", defaultValue: "Applied globally to all repositories on your Mac. [Learn more...](https://git-scm.com/docs/git-config)", comment: "Git configuration section description"))
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
                Text(String(localized: "settings.source-control.git.ignored-files-header", defaultValue: "Ignored Files", comment: "Ignored files section header"))
                Text(String(localized: "settings.source-control.git.ignored-files-description", defaultValue: "Patterns for files and folders that Git should ignore and not track. Applied globally to all repositories on your Mac. [Learn more...](https://git-scm.com/docs/gitignore)", comment: "Ignored files section description"))
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
        TextField(String(localized: "settings.source-control.git.author-name", defaultValue: "Author Name", comment: "Author name field label"), text: $authorName)
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
        TextField(String(localized: "settings.source-control.git.author-email", defaultValue: "Author Email", comment: "Author email field label"), text: $authorEmail)
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
            Text(String(localized: "settings.source-control.git.default-branch", defaultValue: "Default branch name", comment: "Default branch name field label"))
            Text(String(localized: "settings.source-control.git.default-branch-hint", defaultValue: "Cannot contain spaces, backslashes, or other symbols", comment: "Default branch name hint"))
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
            String(localized: "settings.source-control.git.prefer-rebase", defaultValue: "Prefer to rebase when pulling", comment: "Prefer to rebase when pulling toggle"),
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
            String(localized: "settings.source-control.git.show-merge-commits", defaultValue: "Show merge commits in per-file log", comment: "Show merge commits in per-file log toggle"),
            isOn: $git.showMergeCommitsPerFileLog
        )
    }

    private var gitConfigEditor: some View {
        HStack {
            Text(String(localized: "settings.source-control.git.config-location", defaultValue: "Git configuration is stored in \"~/.gitconfig\".", comment: "Git configuration file location info"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "settings.source-control.git.open-in-editor", defaultValue: "Open in Editor...", comment: "Open in editor button"), action: openGitConfigFile)
        }
        .frame(maxWidth: .infinity)
    }

    private var gitIgnoreEditor: some View {
        HStack {
            Text(String(format: String(localized: "settings.source-control.git.ignored-files-location", defaultValue: "Ignored file patterns are stored in \"%@\".", comment: "Ignored files location info"), resolvedGitIgnorePath))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "settings.source-control.git.open-in-editor-ignore", defaultValue: "Open in Editor...", comment: "Open gitignore in editor button"), action: openGitIgnoreFile)
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
