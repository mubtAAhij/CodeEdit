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
        CommandMenu(String(localized: "window-commands.editor.menu-title", defaultValue: "Editor", comment: "Top-level window command menu title for editor actions")) {
            Menu(String(localized: "window-commands.editor.structure.menu-title", defaultValue: "Structure", comment: "Submenu title for editor structure commands")) {
                Button(String(localized: "window-commands.editor.structure.move-line-up", defaultValue: "Move line up", comment: "Command title for moving current line upward")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window-commands.editor.structure.move-line-down", defaultValue: "Move line down", comment: "Command title for moving current line downward")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
