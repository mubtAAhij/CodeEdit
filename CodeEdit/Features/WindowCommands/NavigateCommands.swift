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
        CommandMenu(String(localized: "window-commands.navigate.title", defaultValue: "Navigate", comment: "Top-level Navigate menu title in window commands")) {
            Group {
                Button(String(localized: "window-commands.navigate.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Navigate menu command to reveal current item in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "window-commands.navigate.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Navigate menu command to reveal changes in navigator")) {}
                    .keyboardShortcut("m", modifiers: [.shift, .command])
                    .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Navigate menu command to open current item in next editor")) {}
                    .keyboardShortcut(",", modifiers: [.option, .command])
                    .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in", defaultValue: "Open in...", comment: "Navigate menu command to open current item in another location")) {}
                    .disabled(true)

                Divider()
            }
            Group {
                Button(String(localized: "window-commands.navigate.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Navigate menu command to switch to previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs

                Button(String(localized: "window-commands.navigate.show-next-tab", defaultValue: "Show Next Tab", comment: "Navigate menu command to switch to next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "window-commands.navigate.go-forward", defaultValue: "Go Forward", comment: "Navigate menu command to go forward in navigation history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "window-commands.navigate.go-back", defaultValue: "Go Back", comment: "Navigate menu command to go back in navigation history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
