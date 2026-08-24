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
        CommandMenu(String(localized: "window-commands.editor.menu-title", defaultValue: "Editor", comment: "Title of the editor command menu")) {
            Menu(String(localized: "window-commands.editor.structure", defaultValue: "Structure", comment: "Command title for showing document structure")) {
                Button(String(localized: "window-commands.editor.move-line-up", defaultValue: "Move line up", comment: "Command title for moving the current line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window-commands.editor.move-line-down", defaultValue: "Move line down", comment: "Command title for moving the current line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
