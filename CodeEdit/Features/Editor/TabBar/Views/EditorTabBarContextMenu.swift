//
//  EditorTabBarContextMenu.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/4/22.
//

import SwiftUI
import Foundation

extension View {
    func tabBarContextMenu(item: CEWorkspaceFile, isTemporary: Bool) -> some View {
        modifier(EditorTabBarContextMenu(item: item, isTemporary: isTemporary))
    }
}

struct EditorTabBarContextMenu: ViewModifier {
    init(
        item: CEWorkspaceFile,
        isTemporary: Bool
    ) {
        self.item = item
        self.isTemporary = isTemporary
    }

    @EnvironmentObject var workspace: WorkspaceDocument

    @EnvironmentObject var tabs: Editor

    @Environment(\.splitEditor)
    var splitEditor

    private var item: CEWorkspaceFile
    private var isTemporary: Bool

    // swiftlint:disable:next function_body_length
    func body(content: Content) -> some View {
        content.contextMenu(menuItems: {
            Group {
                Button("String(localized: "close_tab", comment: "Context menu option to close a tab")") {
                    withAnimation {
                        tabs.closeTab(file: item)
                    }
                }
                .keyboardShortcut("w", modifiers: [.command])

                Button("String(localized: "close_other_tabs", comment: "Context menu option to close all other tabs")") {
                    withAnimation {
                        tabs.tabs.map({ $0.file }).forEach { file in
                            if file != item {
                                tabs.closeTab(file: file)
                            }
                        }
                    }
                }

                Button("String(localized: "close_tabs_to_right", comment: "Context menu option to close tabs to the right")") {
                    withAnimation {
                        if let index = tabs.tabs.firstIndex(where: { $0.file == item }), index + 1 < tabs.tabs.count {
                            tabs.tabs[(index + 1)...].forEach {
                                tabs.closeTab(file: $0.file)
                            }
                        }
                    }
                }
                // Disable this option when current tab is the last one.
                .disabled(tabs.tabs.last?.file == item)

                Button("String(localized: "close_all", comment: "Context menu option to close all tabs")") {
                    withAnimation {
                        tabs.tabs.forEach {
                            tabs.closeTab(file: $0.file)
                        }
                    }
                }

                if isTemporary {
                    Button("String(localized: "keep_open", comment: "Context menu option to keep a temporary tab open")") {
                        tabs.temporaryTab = nil
                    }
                }
            }

            Divider()

            Group {
                Button("Copy Path") {
                    copyPath(item: item)
                }

                Button("String(localized: "copy_relative_path", comment: "Context menu option to copy the relative path of a file")") {
                    copyRelativePath(item: item)
                }
            }

            Divider()

            Group {
                Button("Show in Finder") {
                    item.showInFinder()
                }

                Button("String(localized: "reveal_in_project_navigator", comment: "Context menu option to highlight file in project navigator")") {
                    workspace.listenerModel.highlightedFileItem = item
                }

                Button("String(localized: "open_in_new_window", comment: "Context menu option to open file in new window")") {

                }
                .disabled(true)
            }

            Divider()

            Button("String(localized: "split_up", comment: "Context menu option to split editor upward")") {
                moveToNewSplit(.top)
            }
            Button("String(localized: "split_down", comment: "Context menu option to split editor downward")") {
                moveToNewSplit(.bottom)
            }
            Button("String(localized: "split_left", comment: "Context menu option to split editor to the left")") {
                moveToNewSplit(.leading)
            }
            Button("String(localized: "split_right", comment: "Context menu option to split editor to the right")") {
                moveToNewSplit(.trailing)
            }
        })
    }

    // MARK: - Actions

    /// Copies the absolute path of the given `FileItem`
    /// - Parameter item: The `FileItem` to use.
    private func copyPath(item: CEWorkspaceFile) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.url.standardizedFileURL.path, forType: .string)
    }

    func moveToNewSplit(_ edge: Edge) {
        let newEditor = Editor(files: [item], workspace: workspace)
        splitEditor(edge, newEditor)
        tabs.closeTab(file: item)
        workspace.editorManager?.activeEditor = newEditor
    }

    /// Copies the relative path from the workspace folder to the given file item to the pasteboard.
    /// - Parameter item: The `FileItem` to use.
    private func copyRelativePath(item: CEWorkspaceFile) {
        guard let rootPath = workspace.workspaceFileManager?.folderUrl else {
            return
        }
        let destinationComponents = item.url.standardizedFileURL.pathComponents
        let baseComponents = rootPath.standardizedFileURL.pathComponents

        // Find common prefix length
        var prefixCount = 0
        while prefixCount < min(destinationComponents.count, baseComponents.count)
                && destinationComponents[prefixCount] == baseComponents[prefixCount] {
            prefixCount += 1
        }
        // Build the relative path
        let upPath = String(repeating: "../", count: baseComponents.count - prefixCount)
        let downPath = destinationComponents[prefixCount...].joined(separator: "/")

        // Copy it to the clipboard
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(upPath + downPath, forType: .string)
    }
}
