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
                    String(localized: "source-control.changes-tab", defaultValue: "Changes", comment: "Tab title for changes view"),
                    String(localized: "source-control.history-tab", defaultValue: "History", comment: "Tab title for history view"),
                    String(localized: "source-control.repository-tab", defaultValue: "Repository", comment: "Tab title for repository view")
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
                String(localized: "source-control.no-repository", defaultValue: "No Repository", comment: "Message shown when project is not a git repository"),
                 description: String(localized: "source-control.not-git-repository", defaultValue: "This project is not a git repository.", comment: "Description shown when project is not a git repository"),
                 systemImage: "externaldrive.fill",
                 actions: {
                    Button(String(localized: "source-control.initialize", defaultValue: "Initialize", comment: "Button to initialize git repository")) {
                        Task {
                            try await sourceControlManager.initiate()
                        }
                    }
                }
            )
        }
    }
}
