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
                    String(localized: "source-control.commit-message-required", defaultValue: "Commit message (required)", comment: "Commit message field placeholder"),
                    text: $message,
                    axis: .vertical
                )
                .lineLimit(1...3)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if showDetails {
                        VStack {
                            TextField(
                                String(localized: "source-control.detailed-description", defaultValue: "Detailed description", comment: "Detailed description field placeholder"),
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
                            Text(String(localized: "source-control.amend", defaultValue: "Amend", comment: "Amend commit toggle"))
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
                        Text(allFilesStaged ? String(localized: "source-control.unstage-all", defaultValue: "Unstage All", comment: "Unstage all button") : String(localized: "source-control.stage-all", defaultValue: "Stage All", comment: "Stage all button"))
                            .frame(maxWidth: .infinity)
                    }
                    Menu(isCommiting ? String(localized: "source-control.committing", defaultValue: "Committing...", comment: "Committing status") : String(localized: "source-control.commit-button", defaultValue: "Commit", comment: "Commit button")) {
                        Button(String(localized: "source-control.commit-and-push", defaultValue: "Commit and Push...", comment: "Commit and push button")) {
                            Task {
                                self.isCommiting = true
                                do {
                                    try await sourceControlManager.commit(message: message, details: details)
                                    self.message = ""
                                    self.details = ""
                                } catch {
                                    await sourceControlManager.showAlertForError(
                                        title: String(localized: "source-control.failed-to-commit", defaultValue: "Failed to commit", comment: "Failed to commit error title"),
                                        error: error
                                    )
                                }
                                do {
                                    try await sourceControlManager.push()
                                } catch {
                                    await sourceControlManager.showAlertForError(title: String(localized: "source-control.failed-to-push", defaultValue: "Failed to push", comment: "Failed to push error title"), error: error)
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
                                await sourceControlManager.showAlertForError(title: String(localized: "source-control.failed-to-commit", defaultValue: "Failed to commit", comment: "Failed to commit error title"), error: error)
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
            sourceControlManager.logger.error(String(format: NSLocalizedString("source-control.failed-to-stage-all-files", comment: "Failed to stage all files log message"), String(describing: error)))
        }
    }

    /// Resets all changed files.
    private func resetAll() async {
        do {
            try await sourceControlManager.reset(
                sourceControlManager.changedFiles.map { $0.fileURL }
            )
        } catch {
            sourceControlManager.logger.error(String(format: NSLocalizedString("source-control.failed-to-reset-all-files", comment: "Failed to reset all files log message"), String(describing: error)))
        }
    }
}
