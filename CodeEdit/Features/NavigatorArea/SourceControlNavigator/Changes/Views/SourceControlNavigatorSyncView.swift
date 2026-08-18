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
                        Text(String(format: String(localized: "navigator.source-control.sync.no-tracked-branch", defaultValue: "No tracked branch for '%@'", comment: "Message shown when current branch has no tracked upstream branch"), "\(sourceControlManager.currentBranch?.name ?? "")"))
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
                        Text(String(localized: "navigator.source-control.sync.pull", defaultValue: "Pull...", comment: "Button title to open pull operation sheet"))
                    }
                    .disabled(isLoading)
                } else if sourceControlManager.numberOfUnsyncedCommits.ahead > 0
                    || currentBranch.upstream == nil {
                    Button {
                        sourceControlManager.pushSheetIsPresented = true
                    } label: {
                        Text(String(localized: "navigator.source-control.sync.push", defaultValue: "Push...", comment: "Button title to open push operation sheet"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "navigator.source-control.sync.failed-to-pull", defaultValue: "Failed to pull", comment: "Error title shown when pull operation fails"), error: error)
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
                await sourceControlManager.showAlertForError(title: String(localized: "navigator.source-control.sync.failed-to-push", defaultValue: "Failed to push", comment: "Error title shown when push operation fails"), error: error)
            }
            self.isLoading = false
        }
    }

    func formatUnsyncedlabel(ahead: Int?, behind: Int?) -> String {
        var parts: [String] = []

        if let ahead = ahead, ahead > 0 {
            parts.append(String(format: String(localized: "navigator.source-control.sync.ahead-count", defaultValue: "%d ahead", comment: "Status text showing how many commits branch is ahead of remote"), ahead))
        }

        if let behind = behind, behind > 0 {
            parts.append(String(format: String(localized: "navigator.source-control.sync.behind-count", defaultValue: "%d behind", comment: "Status text showing how many commits branch is behind remote"), behind))
        }

        return parts.joined(separator: ", ")
    }
}
