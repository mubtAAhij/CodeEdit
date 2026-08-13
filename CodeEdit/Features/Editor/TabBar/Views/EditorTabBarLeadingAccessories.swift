//
//  EditorTabBarLeadingAccessories.swift
//  CodeEdit
//
//  Created by Austin Condiff on 9/7/23.
//

import SwiftUI

struct EditorTabBarLeadingAccessories: View {
    @Environment(\.controlActiveState)
    private var activeState

    @EnvironmentObject private var editorManager: EditorManager
    @EnvironmentObject private var editor: Editor

    @State private var otherEditor: Editor?

    var body: some View {
        HStack(spacing: 0) {
            if otherEditor != nil {
                EditorTabBarAccessoryIcon(
                    icon: .init(systemName: "multiply"),
                    action: { [weak editor] in
                        guard let editor else { return }
                        editorManager.closeEditor(editor)
                    }
                )
                .help(String(localized: "editor.tab-bar.leading.close-this-editor", defaultValue: "Close this Editor", comment: "Help text for closing the current editor in split view"))
                .disabled(editorManager.isFocusingActiveEditor)
                .opacity(editorManager.isFocusingActiveEditor ? 0.5 : 1)

                EditorTabBarAccessoryIcon(
                    icon: .init(
                        systemName: editorManager.isFocusingActiveEditor
                        ? "arrow.down.forward.and.arrow.up.backward"
                        : "arrow.up.left.and.arrow.down.right"
                    ),
                    isActive: editorManager.isFocusingActiveEditor,
                    action: {
                        editorManager.toggleFocusingEditor(from: editor)
                    }
                )
                .help(
                    editorManager.isFocusingActiveEditor
                    ? String(localized: "editor.tab-bar.leading.unfocus-this-editor", defaultValue: "Unfocus this Editor", comment: "Help text for leaving focused-editor mode")
                    : String(localized: "editor.tab-bar.leading.focus-this-editor", defaultValue: "Focus this Editor", comment: "Help text for entering focused-editor mode")
                )

                Divider()
                    .frame(height: 10)
                    .padding(.horizontal, 4)
            }

            EditorHistoryMenus()
        }
        .foregroundColor(.secondary)
        .buttonStyle(.plain)
        .padding(.horizontal, 5)
        .opacity(activeState != .inactive ? 1.0 : 0.5)
        .frame(maxHeight: .infinity) // Fill out vertical spaces.
        .onAppear {
            otherEditor = editorManager.editorLayout.findSomeEditor(except: editor)
        }
        .onReceive(editorManager.objectWillChange) { _ in
            otherEditor = editorManager.editorLayout.findSomeEditor(except: editor)
        }
    }
}
