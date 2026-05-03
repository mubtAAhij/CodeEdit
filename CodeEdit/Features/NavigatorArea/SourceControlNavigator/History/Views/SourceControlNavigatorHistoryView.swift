//
//  SourceControlNavigatorHistoryView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 12/27/2023.
//

import SwiftUI
import CodeEditSymbols

struct SourceControlNavigatorHistoryView: View {
    enum Status {
        case loading
        case ready
        case error(error: Error)
    }

    @AppSettings(\.sourceControl.git.showMergeCommitsPerFileLog)
    var showMergeCommitsPerFileLog

    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State var commitHistoryStatus: Status = .loading
    @State var commitHistory: [GitCommit] = []

    @State var selection: GitCommit?
    @State private var width: CGFloat = CGFloat.zero

    func updateCommitHistory() async {
        do {
            commitHistoryStatus = .loading
            let commits = try await sourceControlManager
                .gitClient
                .getCommitHistory(
                    branchName: sourceControlManager.currentBranch?.name,
                    showMergeCommits: Settings.shared.preferences.sourceControl.git.showMergeCommitsPerFileLog
                )
            await MainActor.run {
                commitHistory = commits
                commitHistoryStatus = .ready
            }
        } catch {
            sourceControlManager.logger.log(String(format: String(localized: "source_control.history.load_failed", defaultValue: "Failed to load commit history: %@", comment: "Failed to load commit history error"), String(describing: error)))
            await MainActor.run {
                commitHistory = []
                commitHistoryStatus = .error(error: error)
            }
        }
    }

    var body: some View {
        Group {
            switch commitHistoryStatus {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView {
                        Text(String(localized: "source_control.history.loading", defaultValue: "Loading History", comment: "Loading history progress message"))
                    }
                    Spacer()
                }
            case .ready:
                if commitHistory.isEmpty {
                    CEContentUnavailableView(String(localized: "source_control.history.empty", defaultValue: "No History", comment: "No history message"))
                } else {
                    GeometryReader { geometry in
                        ZStack {
                            List(selection: $selection) {
                                ForEach(commitHistory) { commit in
                                    CommitListItemView(commit: commit, showRef: true, width: width)
                                        .tag(commit)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .opacity(selection == nil ? 1 : 0)
                            if selection != nil {
                                CommitDetailsView(commit: $selection)
                            }
                        }
                        .onAppear {
                            self.width = geometry.size.width
                        }
                        .onChange(of: geometry.size.width) { _, newWidth in
                            self.width = newWidth
                        }
                    }
                }
            case .error(let error):
                VStack {
                    Spacer()
                    CEContentUnavailableView(
                        String(localized: "source_control.history.error", defaultValue: "Error Loading History", comment: "Error loading history message"),
                        description: error.localizedDescription,
                        systemImage: String(localized: "source_control.history.error_icon", defaultValue: "exclamationmark.triangle", comment: "Error icon for history loading failure")
                    ) {
                        Button {
                            Task {
                                await updateCommitHistory()
                            }
                        } label: {
                            Text(String(localized: "source_control.history.retry", defaultValue: "Retry", comment: "Retry button"))
                        }
                    }
                    Spacer()
                }
            }
        }
        .task {
            await updateCommitHistory()
        }
        .onChange(of: showMergeCommitsPerFileLog) { _, _ in
            Task {
                await updateCommitHistory()
            }
        }
    }
}
