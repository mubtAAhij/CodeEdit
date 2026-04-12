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
        workspace.workspaceFileManager?.folderUrl.lastPathComponent ?? String(localized: "empty", defaultValue: "Empty", comment: "Empty workspace label")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 20) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(format: String(localized: "source-control.fetching-changes-for", defaultValue: "Fetching changes for \"%@\"...", comment: "Title when fetching changes for project"), projectName))
                        .font(.headline)
                    Text(String(localized: "source-control.fetching-changes-description", defaultValue: "CodeEdit is fetching changes and updating the status of files in the local repository.", comment: "Description of fetch changes operation"))
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
                    Text(String(localized: "source-control.fetching-changes", defaultValue: "Fetching changes...", comment: "Status message while fetching changes"))
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.failed-to-fetch", defaultValue: "Failed to fetch changes", comment: "Error title when fetching changes fails"), error: error)
            }
        }
    }
}
