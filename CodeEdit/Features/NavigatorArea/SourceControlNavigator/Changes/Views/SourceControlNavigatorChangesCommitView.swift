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
                    String(localized: "source_control.commit.message_placeholder", defaultValue: "Commit message (required)", comment: "Placeholder for commit message field"),
                    text: $message,
                    axis: .vertical
                )
                .lineLimit(1...3)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if showDetails {
                        VStack {
                            TextField(
                                String(localized: "source_control.commit.details_placeholder", defaultValue: "Detailed description", comment: "Placeholder for detailed commit description field"),
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
                            Text(String(localized: "source_control.commit.amend", defaultValue: "Amend", comment: "Toggle label for amending previous commit"))
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
                        Text(allFilesStaged ? String(localized: "source_control.commit.unstage_all", defaultValue: "Unstage All", comment: "Button label to unstage all files") : String(localized: "source_control.commit.stage_all", defaultValue: "Stage All", comment: "Button label to stage all files"))
                            .frame(maxWidth: .infinity)
                    }
                    Menu(isCommiting ? String(localized: "source_control.commit.committing_status", defaultValue: "Committing...", comment: "Status message while committing") : String(localized: "source_control.commit.commit_button", defaultValue: "Commit", comment: "Button label to commit changes")) {
                        Button(String(localized: "source_control.commit.commit_and_push", defaultValue: "Commit and Push...", comment: "Button label to commit and push changes")) {
                            Task {
                                self.isCommiting = true
                                do {
                                    try await sourceControlManager.commit(message: message, details: details)
                                    self.message = ""
                                    self.details = ""
                                } catch {
                                    await sourceControlManager.showAlertForError(
                                        title: String(localized: "source_control.commit.error.failed_to_commit", defaultValue: "Failed to commit", comment: "Error alert title when commit fails"),
                                        error: error
                                    )
                                }
                                do {
                                    try await sourceControlManager.push()
                                } catch {
                                    await sourceControlManager.showAlertForError(title: String(localized: "source_control.commit.error.failed_to_push", defaultValue: "Failed to push", comment: "Error alert title when push fails"), error: error)
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
                                await sourceControlManager.showAlertForError(title: String(localized: "source_control.commit.error.failed_to_commit", defaultValue: "Failed to commit", comment: "Error alert title when commit fails"), error: error)
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
            .onChange(of: message) { _, _ in
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
