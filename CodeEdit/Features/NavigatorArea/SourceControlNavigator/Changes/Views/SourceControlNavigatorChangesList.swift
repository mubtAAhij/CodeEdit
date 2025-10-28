//
//  SourceControlNavigatorChangesList.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/18/23.
//

import AppKit
import SwiftUI

struct SourceControlNavigatorChangesList: View {
    @EnvironmentObject var workspace: WorkspaceDocument
    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State var selection = Set<GitChangedFile>()

    var body: some View {
        List($sourceControlManager.changedFiles, selection: $selection) { $file in
            GitChangedFileListView(changedFile: $file)
                .listRowSeparator(.hidden)
                .padding(.vertical, -1)
                .tag($file.wrappedValue)
        }
        .environment(\.defaultMinListRowHeight, 22)
        .contextMenu(
            forSelectionType: GitChangedFile.self,
            menu: { selectedFiles in
                if selectedFiles.count == 1,
                   let file = selectedFiles.first {
                    Group {
                        Button("source_control.view_in_finder", comment: "Menu item") {
                            NSWorkspace.shared.activateFileViewerSelecting([file.fileURL.absoluteURL])
                        }
                        Button("source_control.reveal_in_project_navigator", comment: "Menu item") {}
                            .disabled(true) // TODO: Implementation Needed
                        Divider()
                    }
                    Group {
                        Button("actions.open_in_new_tab", comment: "Menu item") {
                            openGitFile(file)
                        }
                        Button("actions.open_in_new_window", comment: "Menu item") {}
                            .disabled(true) // TODO: Implementation Needed
                    }
                    if file.anyStatus() != .none {
                        Group {
                            Divider()
                            Button("source_control.discard_changes \(file.fileURL.lastPathComponent)", comment: "Menu item") {
                                sourceControlManager.discardChanges(for: file.fileURL)
                            }
                            Divider()
                        }
                    }
                } else {
                    EmptyView()
                }
            },
            // double-click action
            primaryAction: { selectedFiles in
                if selectedFiles.count == 1,
                   let file = selectedFiles.first {
                    openGitFile(file)
                }
            }
        )
        .onChange(of: selection) { newSelection in
            if newSelection.count == 1,
               let file = newSelection.first {
                openGitFile(file)
            }
        }
    }

    private func openGitFile(_ file: GitChangedFile) {
        guard let ceFile = workspace.workspaceFileManager?.getFile(file.ceFileKey, createIfNotFound: true) else {
            return
        }
        DispatchQueue.main.async {
            workspace.editorManager?.openTab(item: ceFile, asTemporary: true)
        }
    }
}
