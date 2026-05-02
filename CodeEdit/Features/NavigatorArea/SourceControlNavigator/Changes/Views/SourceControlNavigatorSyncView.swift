//
//  SourceControlNavigatorSyncView.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/20/23.
//

import SwiftUI

struct SourceControlNavigatorSyncView: View {
    @ObservedObject var sourceControlManager: SourceControlManager
    @State private var isLoading: Bool = false

    var body: some View {
        if let currentBranch = sourceControlManager.currentBranch {
            HStack {
                if currentBranch.upstream == nil {
                    Label(title: {
                        Text(String(format: String(localized: "source-control.sync.no-tracked-branch", defaultValue: "No tracked branch for '%@'", comment: "Message when there is no tracked branch"), sourceControlManager.currentBranch?.name ?? ""))
                    }, icon: {
                        Image(symbol: "branch")
                            .foregroundStyle(.secondary)
                    })
                } else {
                    Label(title: {
                        Text(
                            formatUnsyncedlabel(
                                ahead: sourceControlManager.numberOfUnsyncedCommits.ahead,
                                behind: sourceControlManager.numberOfUnsyncedCommits.behind
                            )
                        )
                    }, icon: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundStyle(.secondary)
                    })
                }

                Spacer()
                if sourceControlManager.numberOfUnsyncedCommits.behind > 0 {
                    Button {
                        sourceControlManager.pullSheetIsPresented = true
                    } label: {
                        Text(String(localized: "source-control.sync.pull", defaultValue: "Pull...", comment: "Pull button label"))
                    }
                    .disabled(isLoading)
                } else if sourceControlManager.numberOfUnsyncedCommits.ahead > 0
                    || currentBranch.upstream == nil {
                    Button {
                        sourceControlManager.pushSheetIsPresented = true
                    } label: {
                        Text(String(localized: "source-control.sync.push", defaultValue: "Push...", comment: "Push button label"))
                    }
                    .disabled(isLoading)
                }
            }
        }
    }

    func pull() {
        Task(priority: .background) {
            self.isLoading = true
            do {
                try await sourceControlManager.pull()
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.sync.pull-error", defaultValue: "Failed to pull", comment: "Error alert when pull fails"), error: error)
            }
            self.isLoading = false
        }
    }

    func push() {
        Task(priority: .background) {
            self.isLoading = true
            do {
                try await sourceControlManager.push()
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.sync.push-error", defaultValue: "Failed to push", comment: "Error alert when push fails"), error: error)
            }
            self.isLoading = false
        }
    }

    func formatUnsyncedlabel(ahead: Int?, behind: Int?) -> String {
        var parts: [String] = []

        if let ahead = ahead, ahead > 0 {
            parts.append(String(format: String(localized: "source-control.sync.ahead", defaultValue: "%d ahead", comment: "Commits ahead status"), ahead))
        }

        if let behind = behind, behind > 0 {
            parts.append(String(format: String(localized: "source-control.sync.behind", defaultValue: "%d behind", comment: "Commits behind status"), behind))
        }

        return parts.joined(separator: String(localized: "source-control.sync.separator", defaultValue: ", ", comment: "Separator between ahead and behind counts"))
    }
}
