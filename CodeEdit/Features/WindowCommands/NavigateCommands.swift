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
        CommandMenu(String(localized: "window_commands.navigate.menu_title", defaultValue: "Navigate", comment: "Top-level Navigate menu title")) {
            Group {
                Button(String(localized: "window_commands.navigate.reveal_in_project_navigator", defaultValue: "Reveal in Project Navigator", comment: "Command title to reveal current file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "window_commands.navigate.reveal_changes_in_navigator", defaultValue: "Reveal Changes in Navigator", comment: "Command title to reveal source control changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "window_commands.navigate.open_in_next_editor", defaultValue: "Open in Next Editor", comment: "Command title to open item in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "window_commands.navigate.open_in", defaultValue: "Open in...", comment: "Command title to open item in a selected destination")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "window_commands.navigate.show_previous_tab", defaultValue: "Show Previous Tab", comment: "Command title to switch to previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "window_commands.navigate.show_next_tab", defaultValue: "Show Next Tab", comment: "Command title to switch to next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "window_commands.navigate.go_forward", defaultValue: "Go Forward", comment: "Command title to navigate forward in history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "window_commands.navigate.go_back", defaultValue: "Go Back", comment: "Command title to navigate backward in history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
