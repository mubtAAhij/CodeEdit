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
        CommandMenu(String(localized: "window-commands.navigate.menu-title", defaultValue: "Navigate", comment: "Title for the Navigate command menu")) {
            Group {
                Button(String(localized: "window-commands.navigate.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Command to reveal current file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "window-commands.navigate.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Command to reveal changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Command to open file in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in-ellipsis", defaultValue: "Open in...", comment: "Command to open file in another editor location")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "window-commands.navigate.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Command to switch to previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "window-commands.navigate.show-next-tab", defaultValue: "Show Next Tab", comment: "Command to switch to next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "window-commands.navigate.go-forward", defaultValue: "Go Forward", comment: "Command to go forward in navigation history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "window-commands.navigate.go-back", defaultValue: "Go Back", comment: "Command to go back in navigation history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
