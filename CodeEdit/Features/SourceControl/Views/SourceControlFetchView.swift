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
        workspace.workspaceFileManager?.folderUrl.lastPathComponent ?? "Empty"
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 20) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Fetching changes for “\(projectName)”...")
                        .font(.headline)
                    Text(String(localized: "source-control.fetch.description", defaultValue: "CodeEdit is fetching changes and updating the status of files in the local repository.", comment: "Description shown while fetch operation is in progress."))
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
                    Text(String(localized: "source-control.fetch.progress", defaultValue: "Fetching changes...", comment: "Inline progress label for source control fetch operation."))
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "source-control.fetch.cancel", defaultValue: "Cancel", comment: "Button title to cancel source control fetch operation."))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.fetch.failed", defaultValue: "Failed to fetch changes", comment: "Error title shown when source control fetch fails."), error: error)
            }
        }
    }
}
