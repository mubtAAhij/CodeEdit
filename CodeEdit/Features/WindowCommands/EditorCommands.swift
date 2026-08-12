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
        CommandMenu(String(localized: "windowcommands.editor.title", defaultValue: "Editor", comment: "Top-level title for the Editor commands menu")) {
            Menu(String(localized: "windowcommands.editor.structure.title", defaultValue: "Structure", comment: "Title for the Structure submenu in Editor commands")) {
                Button(String(localized: "windowcommands.editor.move-line-up", defaultValue: "Move line up", comment: "Command title to move the current line upward")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "windowcommands.editor.move-line-down", defaultValue: "Move line down", comment: "Command title to move the current line downward")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
