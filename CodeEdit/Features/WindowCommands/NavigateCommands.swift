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
        CommandMenu(String(localized: "window-commands.navigate.menu-title", defaultValue: "Navigate", comment: "Top-level navigate command menu title")) {
            Group {
                Button(String(localized: "window-commands.navigate.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Menu item to reveal current file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "window-commands.navigate.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Menu item to reveal source control changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Menu item to open current file in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "window-commands.navigate.open-in", defaultValue: "Open in...", comment: "Menu item to choose where to open current file")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "window-commands.navigate.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Menu item to show previous editor tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "window-commands.navigate.show-next-tab", defaultValue: "Show Next Tab", comment: "Menu item to show next editor tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "window-commands.navigate.go-forward", defaultValue: "Go Forward", comment: "Menu item to navigate forward in editor history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "window-commands.navigate.go-back", defaultValue: "Go Back", comment: "Menu item to navigate back in editor history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
