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
        CommandMenu(String(localized: "window.navigate.title", defaultValue: "Navigate", comment: "Top-level navigate command menu title")) {
            Group {
                Button(String(localized: "window.navigate.reveal-in-project-navigator", defaultValue: "Reveal in Project Navigator", comment: "Command title to reveal item in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "window.navigate.reveal-changes-in-navigator", defaultValue: "Reveal Changes in Navigator", comment: "Command title to reveal source control changes in navigator")) {}
                    .keyboardShortcut("m", modifiers: [.shift, .command])
                    .disabled(true)

                Button(String(localized: "window.navigate.open-in-next-editor", defaultValue: "Open in Next Editor", comment: "Command title to open selection in next editor")) {}
                    .keyboardShortcut(",", modifiers: [.option, .command])
                    .disabled(true)

                Button(String(localized: "window.navigate.open-in", defaultValue: "Open in...", comment: "Command title to open selection in a chosen destination")) {}
                    .disabled(true)

                Divider()
            }
            Group {
                Button(String(localized: "window.navigate.show-previous-tab", defaultValue: "Show Previous Tab", comment: "Command title to switch to previous editor tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs

                Button(String(localized: "window.navigate.show-next-tab", defaultValue: "Show Next Tab", comment: "Command title to switch to next editor tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1) // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "window.navigate.go-forward", defaultValue: "Go Forward", comment: "Command title to navigate forward in history")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "window.navigate.go-back", defaultValue: "Go Back", comment: "Command title to navigate backward in history")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
