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
        CommandMenu(String(localized: "window-commands.editor.menu-title", defaultValue: "Editor", comment: "Title of the Editor command menu")) {
            Menu(String(localized: "window-commands.editor.structure.menu-title", defaultValue: "Structure", comment: "Title of the Structure submenu in Editor commands")) {
                Button(String(localized: "window-commands.editor.structure.move-line-up", defaultValue: "Move line up", comment: "Command title to move selected line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window-commands.editor.structure.move-line-down", defaultValue: "Move line down", comment: "Command title to move selected line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
