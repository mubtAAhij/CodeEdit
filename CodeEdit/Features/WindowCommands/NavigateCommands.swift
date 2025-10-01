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
        CommandMenu(String(localized: "navigate.navigate", comment: "Menu section title for navigation operations")) {
            Group {
                Button(String(localized: "navigate.reveal_in_project_navigator", comment: "Menu item to reveal current file in project navigator")) {
                    NSApp.sendAction(#selector(ProjectNavigatorViewController.revealFile(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j", modifiers: [.shift, .command])

                Button(String(localized: "navigate.reveal_changes_in_navigator", comment: "Menu item to reveal changes in navigator")) {

                }
                .keyboardShortcut("m", modifiers: [.shift, .command])
                .disabled(true)

                Button(String(localized: "navigate.open_in_next_editor", comment: "Menu item to open file in next editor")) {

                }
                .keyboardShortcut(",", modifiers: [.option, .command])
                .disabled(true)

                Button(String(localized: "navigate.open_in_ellipsis", comment: "Menu item to open file in specified location")) {

                }
                .disabled(true)

                Divider()

            }
            Group {
                Button(String(localized: "navigate.show_previous_tab", comment: "Menu item to show previous tab")) {
                    editor?.selectPreviousTab()
                }
                .keyboardShortcut("{", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs

                Button(String(localized: "navigate.show_next_tab", comment: "Menu item to show next tab")) {
                    editor?.selectNextTab()
                }
                .keyboardShortcut("}", modifiers: [.command])
                .disabled(editor?.tabs.count ?? 0 <= 1)  // Disable if there's one or no tabs
            }
            Group {
                Divider()

                Button(String(localized: "navigate.go_forward", comment: "Menu item to go forward")) {
                    editor?.goForwardInHistory()
                }
                .disabled(!(editor?.canGoForwardInHistory ?? false))

                Button(String(localized: "navigate.go_back", comment: "Menu item to go back")) {
                    editor?.goBackInHistory()
                }
                .disabled(!(editor?.canGoBackInHistory ?? false))
            }
            .disabled(editor == nil)
        }
    }
}
