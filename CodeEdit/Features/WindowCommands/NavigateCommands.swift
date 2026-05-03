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
        CommandMenu(String(localized: "navigate.menu", defaultValue: "Navigate", comment: "Navigate menu")) {
            Group {
                Button(String(localized: "navigate.menu.reveal_in_project_navigator", defaultValue: "Reveal in Project Navigator", comment: "Reveal in Project Navigator menu item")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "navigate.menu.reveal_changes_in_navigator", defaultValue: "Reveal Changes in Navigator", comment: "Reveal Changes in Navigator menu item")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate.menu.open_in_next_editor", defaultValue: "Open in Next Editor", comment: "Open in Next Editor menu item")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate.menu.open_in", defaultValue: "Open in...", comment: "Open in... menu item")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate.menu.show_previous_tab", defaultValue: "Show Previous Tab", comment: "Show Previous Tab menu item")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate.menu.show_next_tab", defaultValue: "Show Next Tab", comment: "Show Next Tab menu item")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate.menu.go_forward", defaultValue: "Go Forward", comment: "Go Forward menu item")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate.menu.go_back", defaultValue: "Go Back", comment: "Go Back menu item")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
