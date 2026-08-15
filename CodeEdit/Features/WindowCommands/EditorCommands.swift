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
        CommandMenu(String(localized: "window-commands.editor.title", defaultValue: "Editor", comment: "Title for the Editor command menu")) {
            Menu(String(localized: "window-commands.editor.structure", defaultValue: "Structure", comment: "Editor command title for opening structure view")) {
                Button(String(localized: "window-commands.editor.move-line-up", defaultValue: "Move line up", comment: "Editor command title to move the current line up")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesUp()
                }
                .keyboardShortcut("[", modifiers: [.command, .option])

                Button(String(localized: "window-commands.editor.move-line-down", defaultValue: "Move line down", comment: "Editor command title to move the current line down")) {
                    editor?.selectedTab?.rangeTranslator.moveLinesDown()
                }
                .keyboardShortcut("]", modifiers: [.command, .option])
            }
        }
    }
}
