//
//  EditorCommands.swift
//  CodeEdit
//
//  Created by Bogdan Belogurov on 21/05/2025.
//

import SwiftUI
import CodeEditKit

struct EditorCommands: Commands {

    @UpdatingWindowController var windowController: CodeEditWindowController?
    private var editor: Editor? {
        windowController?.workspace?.editorManager?.activeEditor
    }

    var body: some Commands {
        CommandMenu(String(localized: "menu.editor", defaultValue: "Editor", comment: "Menu title for editor commands")) {
            Menu(String(localized: "menu.editor.structure", defaultValue: "Structure", comment: "Menu title for structure commands")) {
                Button(String(localized: "menu.editor.structure.move-line-up", defaultValue: "Move line up", comment: "Button to move line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "menu.editor.structure.move-line-down", defaultValue: "Move line down", comment: "Button to move line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
