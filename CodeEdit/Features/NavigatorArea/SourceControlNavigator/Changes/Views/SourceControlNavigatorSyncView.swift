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
                        Text(String(
                            format: String(localized: "source-control.sync.no-tracked-branch", defaultValue: "No tracked branch for '%@'", comment: "Message when current branch has no tracked remote branch"),
                            sourceControlManager.currentBranch?.name ?? ""
                        ))
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
                        Text(String(localized: "source-control.sync.pull", defaultValue: "Pull...", comment: "Button to pull changes from remote repository"))
                    }
                    .disabled(isLoading)
                } else if sourceControlManager.numberOfUnsyncedCommits.ahead > 0
                    || currentBranch.upstream == nil {
                    Button {
                        sourceControlManager.pushSheetIsPresented = true
                    } label: {
                        Text(String(localized: "source-control.sync.push", defaultValue: "Push...", comment: "Button to push changes to remote repository"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.sync.pull-failed", defaultValue: "Failed to pull", comment: "Error title when pulling from remote repository fails"), error: error)
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.sync.push-failed", defaultValue: "Failed to push", comment: "Error title when pushing to remote repository fails"), error: error)
            }
            self.isLoading = false
        }
    }

    func formatUnsyncedlabel(ahead: Int?, behind: Int?) -> String {
        let hasAhead = (ahead ?? 0) > 0
        let hasBehind = (behind ?? 0) > 0

        if hasAhead && hasBehind {
            return String(
                format: String(localized: "source-control.sync.ahead-behind-count", defaultValue: "%d ahead, %d behind", comment: "Shows number of commits ahead and behind remote"),
                ahead ?? 0,
                behind ?? 0
            )
        } else if hasAhead {
            return String(
                format: String(localized: "source-control.sync.ahead-count", defaultValue: "%d ahead", comment: "Shows number of commits ahead of remote"),
                ahead ?? 0
            )
        } else if hasBehind {
            return String(
                format: String(localized: "source-control.sync.behind-count", defaultValue: "%d behind", comment: "Shows number of commits behind remote"),
                behind ?? 0
            )
        }

        return ""
    }
}
