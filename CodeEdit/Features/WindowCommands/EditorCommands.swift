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
        CommandMenu(String(localized: "window-commands.editor.menu", defaultValue: "Editor", comment: "Top-level menu title for editor commands")) {
            Menu(String(localized: "window-commands.editor.structure", defaultValue: "Structure", comment: "Submenu title for editor structure commands")) {
                Button(String(localized: "window-commands.editor.move-line-up", defaultValue: "Move line up", comment: "Command title to move current line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window-commands.editor.move-line-down", defaultValue: "Move line down", comment: "Command title to move current line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
