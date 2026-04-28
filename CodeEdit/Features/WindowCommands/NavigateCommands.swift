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
                Button(String(localized: "navigate.reveal-in-project", defaultValue: "Reveal in Project Navigator", comment: "Reveal in project navigator menu item")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "navigate.reveal-changes", defaultValue: "Reveal Changes in Navigator", comment: "Reveal changes in navigator menu item")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate.open-next-editor", defaultValue: "Open in Next Editor", comment: "Open in next editor menu item")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate.open-in", defaultValue: "Open in...", comment: "Open in menu item")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate.previous-tab", defaultValue: "Show Previous Tab", comment: "Show previous tab menu item")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate.next-tab", defaultValue: "Show Next Tab", comment: "Show next tab menu item")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate.go-forward", defaultValue: "Go Forward", comment: "Go forward menu item")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate.go-back", defaultValue: "Go Back", comment: "Go back menu item")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
