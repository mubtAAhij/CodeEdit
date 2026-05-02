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
        CommandMenu(String(localized: "navigate.menu.title", defaultValue: "Navigate", comment: "Navigate menu title")) {
            Group {
                Button(String(localized: "navigate.reveal-project", defaultValue: "Reveal in Project Navigator", comment: "Button to reveal file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "navigate.reveal-changes", defaultValue: "Reveal Changes in Navigator", comment: "Button to reveal changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate.open-next-editor", defaultValue: "Open in Next Editor", comment: "Button to open in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate.open-in", defaultValue: "Open in...", comment: "Button to open in specific location")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate.previous-tab", defaultValue: "Show Previous Tab", comment: "Button to show previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate.next-tab", defaultValue: "Show Next Tab", comment: "Button to show next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate.forward", defaultValue: "Go Forward", comment: "Button to go forward in history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate.back", defaultValue: "Go Back", comment: "Button to go back in history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
