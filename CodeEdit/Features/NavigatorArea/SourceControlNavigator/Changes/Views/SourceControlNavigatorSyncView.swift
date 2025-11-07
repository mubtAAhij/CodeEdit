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
                        let branchName = sourceControlManager.currentBranch?.name ?? ""
                        Text(String(
                            localized: "source-control-sync.no-tracked-branch",
                            defaultValue: "No tracked branch for '\(branchName)'",
                            comment: "Message when branch has no upstream tracking"
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
                        Text(String(
                            localized: "source-control-sync.pull",
                            defaultValue: "Pull...",
                            comment: "Button to pull changes from remote"
                        ))
                    }
                    .disabled(isLoading)
                } else if sourceControlManager.numberOfUnsyncedCommits.ahead > 0
                    || currentBranch.upstream == nil {
                    Button {
                        sourceControlManager.pushSheetIsPresented = true
                    } label: {
                        Text(String(
                            localized: "source-control-sync.push",
                            defaultValue: "Push...",
                            comment: "Button to push changes to remote"
                        ))
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
                await sourceControlManager.showAlertForError(title: String(
                    localized: "source-control-sync.pull-failed",
                    defaultValue: "Failed to pull",
                    comment: "Error title when pull fails"
                ), error: error)
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
                await sourceControlManager.showAlertForError(title: String(
                    localized: "source-control-sync.push-failed",
                    defaultValue: "Failed to push",
                    comment: "Error title when push fails"
                ), error: error)
            }
            self.isLoading = false
        }
    }

    func formatUnsyncedlabel(ahead: Int?, behind: Int?) -> String {
        var parts: [String] = []

        if let ahead = ahead, ahead > 0 {
            let count = ahead
            parts.append(String(
                localized: "source-control-sync.ahead",
                defaultValue: "\(count) ahead",
                comment: "Label showing commits ahead of remote"
            ))
        }

        if let behind = behind, behind > 0 {
            let count = behind
            parts.append(String(
                localized: "source-control-sync.behind",
                defaultValue: "\(count) behind",
                comment: "Label showing commits behind remote"
            ))
        }

        return parts.joined(separator: ", ")
    }
}
