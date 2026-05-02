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
        CommandMenu(String(localized: "navigate.menu", defaultValue: "Navigate", comment: "Navigate menu title")) {
            Group {
                Button(String(localized: "navigate.reveal.in.project", defaultValue: "Reveal in Project Navigator", comment: "Navigate menu item to reveal file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "navigate.reveal.in.project.shortcut", defaultValue: "j", comment: "Navigate reveal in project keyboard shortcut key"))), modifiers: [.shift, .command])

                Button(String(localized: "navigate.reveal.changes", defaultValue: "Reveal Changes in Navigator", comment: "Navigate menu item to reveal changes in navigator")) {

                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "navigate.reveal.changes.shortcut", defaultValue: "m", comment: "Navigate reveal changes keyboard shortcut key"))), modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate.open.next.editor", defaultValue: "Open in Next Editor", comment: "Navigate menu item to open in next editor")) {

                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "navigate.open.next.editor.shortcut", defaultValue: ",", comment: "Navigate open in next editor keyboard shortcut key"))), modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate.open.in", defaultValue: "Open in...", comment: "Navigate menu item to open in another location")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate.show.previous.tab", defaultValue: "Show Previous Tab", comment: "Navigate menu item to show previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "navigate.show.previous.tab.shortcut", defaultValue: "{", comment: "Navigate show previous tab keyboard shortcut key"))), modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate.show.next.tab", defaultValue: "Show Next Tab", comment: "Navigate menu item to show next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "navigate.show.next.tab.shortcut", defaultValue: "}", comment: "Navigate show next tab keyboard shortcut key"))), modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate.go.forward", defaultValue: "Go Forward", comment: "Navigate menu item to go forward in history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate.go.back", defaultValue: "Go Back", comment: "Navigate menu item to go back in history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
