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
                Button(String(localized: "editor.tab.context-menu.close-tab", defaultValue: "Close Tab", comment: "Context menu item to close the current tab")) {
                    withAnimation {
                        tabs.closeTab(file: item)
                    }
                }
                .keyboardShortcut("w", modifiers: [.command])

                Button(String(localized: "editor.tab.context-menu.close-other-tabs", defaultValue: "Close Other Tabs", comment: "Context menu item to close all tabs except the current one")) {
                    withAnimation {
                        tabs.tabs.map({ $0.file }).forEach { file in
                            if file != item {
                                tabs.closeTab(file: file)
                            }
                        }
                    }
                }

                Button(String(localized: "editor.tab.context-menu.close-tabs-to-right", defaultValue: "Close Tabs to the Right", comment: "Context menu item to close all tabs to the right of the current tab")) {
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

                Button(String(localized: "editor.tab.context-menu.close-all", defaultValue: "Close All", comment: "Context menu item to close all tabs")) {
                    withAnimation {
                        tabs.tabs.forEach {
                            tabs.closeTab(file: $0.file)
                        }
                    }
                }

                if isTemporary {
                    Button(String(localized: "editor.tab.context-menu.keep-open", defaultValue: "Keep Open", comment: "Context menu item to keep temporary tab open")) {
                        tabs.temporaryTab = nil
                    }
                }
            }

            Divider()

            Group {
                Button(String(localized: "editor.tab.context-menu.copy-path", defaultValue: "Copy Path", comment: "Context menu item to copy absolute path")) {
                    copyPath(item: item)
                }

                Button(String(localized: "editor.tab.context-menu.copy-relative-path", defaultValue: "Copy Relative Path", comment: "Context menu item to copy relative path")) {
                    copyRelativePath(item: item)
                }
            }

            Divider()

            Group {
                Button(String(localized: "editor.tab.context-menu.show-in-finder", defaultValue: "Show in Finder", comment: "Context menu item to show file in Finder")) {
                    item.showInFinder()
                }

                Button(String(localized: "editor.tab.context-menu.reveal-in-navigator", defaultValue: "Reveal in Project Navigator", comment: "Context menu item to reveal file in project navigator")) {
                    workspace.listenerModel.highlightedFileItem = item
                }

                Button(String(localized: "editor.tab.context-menu.open-in-new-window", defaultValue: "Open in New Window", comment: "Context menu item to open file in new window")) {

                }
                .disabled(true)
            }

            Divider()

            Button(String(localized: "editor.tab.context-menu.split-up", defaultValue: "Split Up", comment: "Context menu item to split editor upward")) {
                moveToNewSplit(.top)
            }
            Button(String(localized: "editor.tab.context-menu.split-down", defaultValue: "Split Down", comment: "Context menu item to split editor downward")) {
                moveToNewSplit(.bottom)
            }
            Button(String(localized: "editor.tab.context-menu.split-left", defaultValue: "Split Left", comment: "Context menu item to split editor to the left")) {
                moveToNewSplit(.leading)
            }
            Button(String(localized: "editor.tab.context-menu.split-right", defaultValue: "Split Right", comment: "Context menu item to split editor to the right")) {
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
