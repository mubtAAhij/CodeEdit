//
//  SourceControlNavigatorChangesCommitView.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/19/23.
//

import SwiftUI

struct SourceControlNavigatorChangesCommitView: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager
    @State private var message: String = ""
    @State private var details: String = ""
    @State private var ammend: Bool = false
    @State private var showDetails: Bool = false
    @State private var isCommiting: Bool = false

    var allFilesStaged: Bool {
        sourceControlManager.changedFiles.allSatisfy { $0.isStaged }
    }

    var anyFilesStaged: Bool {
        sourceControlManager.changedFiles.contains { $0.isStaged }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                PaneTextField(
                    String(localized: "navigator.source-control.commit.message-prompt", defaultValue: "Commit message (required)", comment: "Text field prompt for commit message"),
                    text: $message,
                    axis: .vertical
                )
                .lineLimit(1...3)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if showDetails {
                        VStack {
                            TextField(
                                String(localized: "navigator.source-control.commit.details-prompt", defaultValue: "Detailed description", comment: "Text field prompt for detailed description"),
                                text: $details,
                                axis: .vertical
                            )
                            .textFieldStyle(.plain)
                            .controlSize(.small)
                            .lineLimit(3...5)

                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3.5)
                        .overlay(alignment: .top) {
                            VStack {
                                Divider()
                            }
                        }
                    }
                }
                VStack(spacing: 0) {
                    if showDetails {
                        Toggle(isOn: $ammend) {
                            Text(String(localized: "navigator.source-control.commit.amend", defaultValue: "Amend", comment: "Toggle to amend previous commit"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity)
                .clipped()
                HStack(spacing: 8) {
                    Button {
                        Task {
                            if allFilesStaged {
                                await resetAll()
                            } else {
                                await stageAll()
                            }
                        }
                    } label: {
                        Text(allFilesStaged ? String(localized: "navigator.source-control.commit.unstage-all", defaultValue: "Unstage All", comment: "Button to unstage all files") : String(localized: "navigator.source-control.commit.stage-all", defaultValue: "Stage All", comment: "Button to stage all files"))
                            .frame(maxWidth: .infinity)
                    }
                    Menu(isCommiting ? String(localized: "navigator.source-control.commit.committing", defaultValue: "Committing...", comment: "Label shown while committing") : String(localized: "navigator.source-control.commit.commit", defaultValue: "Commit", comment: "Button to commit changes")) {
                        Button(String(localized: "navigator.source-control.commit.commit-and-push", defaultValue: "Commit and Push...", comment: "Menu item to commit and push")) {
                            Task {
                                self.isCommiting = true
                                do {
                                    try await sourceControlManager.commit(message: message, details: details)
                                    self.message = ""
                                    self.details = ""
                                } catch {
                                    await sourceControlManager.showAlertForError(
                                        title: String(localized: "navigator.source-control.commit.error.commit", defaultValue: "Failed to commit", comment: "Error title when commit fails"),
                                        error: error
                                    )
                                }
                                do {
                                    try await sourceControlManager.push()
                                } catch {
                                    await sourceControlManager.showAlertForError(title: String(localized: "navigator.source-control.commit.error.push", defaultValue: "Failed to push", comment: "Error title when push fails"), error: error)
                                }
                                self.isCommiting = false
                            }
                        }
                    } primaryAction: {
                        Task {
                            self.isCommiting = true
                            do {
                                try await sourceControlManager.commit(message: message, details: details)
                                self.message = ""
                                self.details = ""
                            } catch {
                                await sourceControlManager.showAlertForError(title: String(localized: "navigator.source-control.commit.error.commit", defaultValue: "Failed to commit", comment: "Error title when commit fails"), error: error)
                            }
                            self.isCommiting = false
                        }
                    }
                    .disabled(
                        message.isEmpty ||
                        !anyFilesStaged ||
                        isCommiting
                    )
                }
                .padding(.top, 8)
            }
            .transition(.move(edge: .top))
            .onChange(of: message) { _ in
                withAnimation(.easeInOut(duration: 0.25)) {
                    showDetails = !message.isEmpty
                }
            }
        }
    }

    /// Stages all changed files.
    private func stageAll() async {
        do {
            try await sourceControlManager.add(sourceControlManager.changedFiles.compactMap {
                $0.stagedStatus == .none ? $0.fileURL : nil
            })
        } catch {
            sourceControlManager.logger.error("Failed to stage all files: \(error)")
        }
    }

    /// Resets all changed files.
    private func resetAll() async {
        do {
            try await sourceControlManager.reset(
                sourceControlManager.changedFiles.map { $0.fileURL }
            )
        } catch {
            sourceControlManager.logger.error("Failed to reset all files: \(error)")
        }
    }
}
