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
                .help(String(localized: "editor.close-editor", defaultValue: "Close this Editor", comment: "Close editor tooltip"))
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
                    ? String(localized: "editor.unfocus-editor", defaultValue: "Unfocus this Editor", comment: "Unfocus editor tooltip")
                    : String(localized: "editor.focus-editor", defaultValue: "Focus this Editor", comment: "Focus editor tooltip")
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
