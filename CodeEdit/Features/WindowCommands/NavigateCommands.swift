//
//  NavigateCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI

struct NavigateCommands: Commands {

    @UpdatingWindowController var windowController: CodeEditWindowController?
    private var editor: Editor? {
        windowController?.workspace?.editorManager?.activeEditor
    }

    var body: some Commands {
        CommandMenu("navigate.menu", comment: "Menu title") {
            Group {
                Button("navigate.reveal_in_project", comment: "Button text") {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button("navigate.reveal_changes", comment: "Button text") {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button("navigate.open_in_next_editor", comment: "Button text") {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button("navigate.open_in", comment: "Button text") {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button("navigate.show_previous_tab", comment: "Button text") {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button("navigate.show_next_tab", comment: "Button text") {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button("navigate.go_forward", comment: "Button text") {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button("navigate.go_back", comment: "Button text") {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
