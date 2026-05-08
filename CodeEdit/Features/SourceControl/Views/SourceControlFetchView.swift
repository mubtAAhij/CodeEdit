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
                    Text(String(format: String(localized: "git.fetch.title", defaultValue: "Fetching changes for \"%@\"...", comment: "Fetching changes title with project name"), projectName))
                        .font(.headline)
                    Text(String(localized: "git.fetch.description", defaultValue: "CodeEdit is fetching changes and updating the status of files in the local repository.", comment: "Fetching changes description"))
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
                    Text(String(localized: "git.fetch.progress", defaultValue: "Fetching changes...", comment: "Fetching changes progress text"))
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "git.fetch.cancel", defaultValue: "Cancel", comment: "Cancel fetch button"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "git.fetch.failed", defaultValue: "Failed to fetch changes", comment: "Failed to fetch changes alert title"), error: error)
            }
        }
    }
}
