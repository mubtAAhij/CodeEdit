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
                        Text(String(format: NSLocalizedString("source-control.no-tracked-branch", comment: "No tracked branch"), sourceControlManager.currentBranch?.name ?? ""))
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
                        Text(String(localized: "source-control.pull-ellipsis", defaultValue: "Pull...", comment: "Pull button"))
                    }
                    .disabled(isLoading)
                } else if sourceControlManager.numberOfUnsyncedCommits.ahead > 0
                    || currentBranch.upstream == nil {
                    Button {
                        sourceControlManager.pushSheetIsPresented = true
                    } label: {
                        Text(String(localized: "source-control.push-ellipsis", defaultValue: "Push...", comment: "Push button"))
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
                await sourceControlManager.showAlertForError(title: NSLocalizedString("source-control.pull-failed", comment: "Failed to pull"), error: error)
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
                await sourceControlManager.showAlertForError(title: NSLocalizedString("source-control.push-failed", comment: "Failed to push"), error: error)
            }
            self.isLoading = false
        }
    }

    func formatUnsyncedlabel(ahead: Int?, behind: Int?) -> String {
        var parts: [String] = []

        if let ahead = ahead, ahead > 0 {
            parts.append(String(format: NSLocalizedString("source-control.ahead", comment: "Ahead count"), ahead))
        }

        if let behind = behind, behind > 0 {
            parts.append(String(format: NSLocalizedString("source-control.behind", comment: "Behind count"), behind))
        }

        return parts.joined(separator: ", ")
    }
}
