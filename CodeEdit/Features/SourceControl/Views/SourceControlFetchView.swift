//
//  SourceControlFetchView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/28/24.
//

import SwiftUI

struct SourceControlFetchView: View {
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject var sourceControlManager: SourceControlManager
    @EnvironmentObject var workspace: WorkspaceDocument

    var projectName: String {
        workspace.workspaceFileManager?.folderUrl.lastPathComponent ?? String(localized: "source-control.empty-project-name", defaultValue: "Empty", comment: "Fallback project name when workspace folder is not available")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 20) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(format: String(localized: "source-control.fetch-title", defaultValue: "Fetching changes for \"%@\"...", comment: "Title for fetch changes dialog"), projectName))
                        .font(.headline)
                    Text(String(localized: "source-control.fetch-message", defaultValue: "CodeEdit is fetching changes and updating the status of files in the local repository.", comment: "Message explaining fetch operation"))
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            HStack {
                HStack(spacing: 7.5) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                    Text(String(localized: "source-control.fetching", defaultValue: "Fetching changes...", comment: "Status message while fetching"))
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "source-control.cancel", defaultValue: "Cancel", comment: "Button to cancel fetch operation"))
                        .frame(minWidth: 48)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 420)
        .task {
            do {
                try await sourceControlManager.fetch()
                dismiss()
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.fetch-failed", defaultValue: "Failed to fetch changes", comment: "Error title when fetch fails"), error: error)
            }
        }
    }
}
