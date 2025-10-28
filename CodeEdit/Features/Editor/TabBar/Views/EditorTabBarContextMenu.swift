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
                Button("editor.tab_menu.close_tab", comment: "Close tab menu item") {
                    withAnimation {
                        tabs.closeTab(file: item)
                    }
                }
                .keyboardShortcut("w", modifiers: [.command])

                Button("editor.tab_menu.close_other_tabs", comment: "Close other tabs menu item") {
                    withAnimation {
                        tabs.tabs.map({ $0.file }).forEach { file in
                            if file != item {
                                tabs.closeTab(file: file)
                            }
                        }
                    }
                }

                Button("editor.tab_menu.close_tabs_to_right", comment: "Close tabs to the right menu item") {
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

                Button("editor.tab_menu.close_all", comment: "Close all tabs menu item") {
                    withAnimation {
                        tabs.tabs.forEach {
                            tabs.closeTab(file: $0.file)
                        }
                    }
                }

                if isTemporary {
                    Button("editor.tab_menu.keep_open", comment: "Keep tab open menu item") {
                        tabs.temporaryTab = nil
                    }
                }
            }

            Divider()

            Group {
                Button("editor.tab_menu.copy_path", comment: "Copy path menu item") {
                    copyPath(item: item)
                }

                Button("editor.tab_menu.copy_relative_path", comment: "Copy relative path menu item") {
                    copyRelativePath(item: item)
                }
            }

            Divider()

            Group {
                Button("editor.tab_menu.show_in_finder", comment: "Show in Finder menu item") {
                    item.showInFinder()
                }

                Button("editor.tab_menu.reveal_in_project_navigator", comment: "Reveal in Project Navigator menu item") {
                    workspace.listenerModel.highlightedFileItem = item
                }

                Button("editor.tab_menu.open_in_new_window", comment: "Open in new window menu item") {

                }
                .disabled(true)
            }

            Divider()

            Button("editor.tab_menu.split_up", comment: "Split up menu item") {
                moveToNewSplit(.top)
            }
            Button("editor.tab_menu.split_down", comment: "Split down menu item") {
                moveToNewSplit(.bottom)
            }
            Button("editor.tab_menu.split_left", comment: "Split left menu item") {
                moveToNewSplit(.leading)
            }
            Button("editor.tab_menu.split_right", comment: "Split right menu item") {
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
