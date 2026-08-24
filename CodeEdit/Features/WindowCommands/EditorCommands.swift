//
//  EditorCommands.swift
//  CodeEdit
//
//  Created by Bogdan Belogurov on 21/05/2025.
//

import CodeEditKit
import SwiftUI

struct EditorCommands: Commands {
    @UpdatingWindowController var windowController: CodeEditWindowController?
    private var editor: Editor? {
        windowController?.workspace?.editorManager?.activeEditor
    }

    var body: some Commands {
        CommandMenu(String(localized: "window.editor.title", defaultValue: "Editor", comment: "Top-level editor command menu title")) {
            Menu(String(localized: "window.editor.structure", defaultValue: "Structure", comment: "Editor submenu title for structure commands")) {
                Button(String(localized: "window.editor.move-line-up", defaultValue: "Move line up", comment: "Command title to move the current line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window.editor.move-line-down", defaultValue: "Move line down", comment: "Command title to move the current line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
