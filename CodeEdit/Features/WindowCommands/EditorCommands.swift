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
        CommandMenu(String(localized: "menu.editor", defaultValue: "Editor", comment: "Editor menu")) {
            Menu(String(localized: "menu.editor.structure", defaultValue: "Structure", comment: "Structure menu")) {
                Button(String(localized: "menu.editor.move-line-up", defaultValue: "Move line up", comment: "Move line up action")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "menu.editor.move-line-down", defaultValue: "Move line down", comment: "Move line down action")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
