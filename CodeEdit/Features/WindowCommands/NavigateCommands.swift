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
        CommandMenu(String(localized: "windowcommands.navigate.title", defaultValue: "Navigate", comment: "Top-level title for the Navigate commands menu")) {
            Group {
                Button(String(localized: "windowcommands.navigate.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Command title to reveal the current item in the project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "windowcommands.navigate.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Command title to reveal changed files in the navigator")) {}
                    .keyboardShortcut("m", modifiers: [.shift, .command])
                    .disabled(true)

                Button(String(localized: "windowcommands.navigate.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Command title to open the current item in the next editor")) {}
                    .keyboardShortcut(",", modifiers: [.option, .command])
                    .disabled(true)

                Button(String(localized: "windowcommands.navigate.open-in", defaultValue: "Open in...", comment: "Command title to choose where to open the current item")) {}
                    .disabled(true)

                Divider()
            }
            Group {
                Button(String(localized: "windowcommands.navigate.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Command title to switch to the previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs

                Button(String(localized: "windowcommands.navigate.show-next-tab", defaultValue: "Show Next Tab", comment: "Command title to switch to the next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "windowcommands.navigate.go-forward", defaultValue: "Go Forward", comment: "Command title to navigate forward in history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "windowcommands.navigate.go-back", defaultValue: "Go Back", comment: "Command title to navigate backward in history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
