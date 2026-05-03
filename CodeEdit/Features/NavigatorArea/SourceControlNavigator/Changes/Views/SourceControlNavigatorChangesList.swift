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
                        Button(String(localized: "common.view_in_finder", defaultValue: "View in Finder", comment: "View in Finder menu item")) {
                            NSWorkspace.shared.activateFileViewerSelecting([file.fileURL.absoluteURL])
                        }
                        Button(String(localized: "navigator.reveal_in_project", defaultValue: "Reveal in Project Navigator", comment: "Reveal in project navigator menu item")) {}
                            .disabled(true) // TODO: Implementation Needed
                        Divider()
                    }
                    Group {
                        Button(String(localized: "common.open_new_tab", defaultValue: "Open in New Tab", comment: "Open in new tab menu item")) {
                            openGitFile(file)
                        }
                        Button(String(localized: "common.open_new_window", defaultValue: "Open in New Window", comment: "Open in new window menu item")) {}
                            .disabled(true) // TODO: Implementation Needed
                    }
                    if file.anyStatus() != .none {
                        Group {
                            Divider()
                            Button(String(
                                format: String(localized: "git.discard_changes", defaultValue: "Discard Changes in %@...", comment: "Discard changes menu item"),
                                file.fileURL.lastPathComponent
                            )) {
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
        .onChange(of: selection) { _, newSelection in
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
