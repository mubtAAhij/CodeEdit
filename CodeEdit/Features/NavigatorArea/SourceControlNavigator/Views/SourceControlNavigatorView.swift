//
//  SourceControlNavigatorView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/05/20.
//

import SwiftUI

struct SourceControlNavigatorView: View {
    @EnvironmentObject private var workspace: WorkspaceDocument

    @AppSettings(\.sourceControl.general.fetchRefreshServerStatus)
    var fetchRefreshServerStatus

    var body: some View {
        if let sourceControlManager = workspace.workspaceFileManager?.sourceControlManager {
            VStack(spacing: 0) {
                SourceControlNavigatorTabs()
                    .environmentObject(sourceControlManager)
                    .task {
                        do {
                            while true {
                                if fetchRefreshServerStatus {
                                    try await sourceControlManager.fetch()
                                }
                                try await Task.sleep(for: .seconds(10))
                            }
                        } catch {
                            // TODO: if source fetching fails, display message
                        }
                    }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                SourceControlNavigatorToolbarBottom()
                    .environmentObject(sourceControlManager)
            }
        }
    }
}

struct SourceControlNavigatorTabs: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager
    @State private var selectedSection: Int = 0

    var body: some View {
        if sourceControlManager.isGitRepository {
            SegmentedControl(
                $selectedSection,
                options: [
                    String(
                        localized: "source-control-navigator.tab.changes",
                        defaultValue: "Changes",
                        comment: "Tab label for source control changes view"
                    ),
                    String(
                        localized: "source-control-navigator.tab.history",
                        defaultValue: "History",
                        comment: "Tab label for source control history view"
                    ),
                    String(
                        localized: "source-control-navigator.tab.repository",
                        defaultValue: "Repository",
                        comment: "Tab label for source control repository view"
                    )
                ],
                prominent: true
            )
            .frame(maxWidth: .infinity)
            .frame(height: 27)
            .padding(.horizontal, 8)
            Divider()
            if selectedSection == 0 {
                SourceControlNavigatorChangesView()
            }
            if selectedSection == 1 {
                SourceControlNavigatorHistoryView()
            }
            if selectedSection == 2 {
                SourceControlNavigatorRepositoryView()
            }
        } else {
            CEContentUnavailableView(
                String(
                    localized: "source-control-navigator.no-repository.title",
                    defaultValue: "No Repository",
                    comment: "Title for empty state when no repository is found"
                ),
                 description: String(
                    localized: "source-control-navigator.no-repository.description",
                    defaultValue: "This project is not a git repository.",
                    comment: "Description for empty state when no repository is found"
                 ),
                 systemImage: "externaldrive.fill",
                 actions: {
                    Button(String(
                        localized: "source-control-navigator.no-repository.initialize",
                        defaultValue: "Initialize",
                        comment: "Button to initialize git repository"
                    )) {
                        Task {
                            try await sourceControlManager.initiate()
                        }
                    }
                }
            )
        }
    }
}
