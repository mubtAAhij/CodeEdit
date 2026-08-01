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
        CommandMenu(String(localized: "navigate-commands.menu-title", defaultValue: "Navigate", comment: "Menu title for navigation commands")) {
            Group {
                Button(String(localized: "navigate-commands.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Button label to reveal file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "navigate-commands.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Button label to reveal changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate-commands.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Button label to open in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate-commands.open-in", defaultValue: "Open in...", comment: "Button label to open in specific editor")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate-commands.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Button label to show previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate-commands.show-next-tab", defaultValue: "Show Next Tab", comment: "Button label to show next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate-commands.go-forward", defaultValue: "Go Forward", comment: "Button label to go forward in navigation history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate-commands.go-back", defaultValue: "Go Back", comment: "Button label to go back in navigation history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
