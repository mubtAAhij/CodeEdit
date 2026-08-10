//
//  FindCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI

struct FindCommands: Commands {
    @FirstResponder var responder

    static let selector = #selector(NSTextView.performFindPanelAction(_:))

    var hasResponder: Bool {
        responder?.responds(to: Self.selector) ?? false
    }

    var body: some Commands {
        CommandMenu(
            String(
                localized: "find.menu.title",
                defaultValue: "Find",
                comment: "Title of the Find command menu"
            )
        ) {
            Group {
                Button(
                    String(
                        localized: "find.command.find",
                        defaultValue: "Find...",
                        comment: "Find command in the Find menu"
                    )
                ) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(
                    String(
                        localized: "find.command.find-and-replace",
                        defaultValue: "Find and Replace...",
                        comment: "Find and Replace command in the Find menu"
                    )
                ) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(
                    String(
                        localized: "find.command.find-next",
                        defaultValue: "Find Next",
                        comment: "Find Next command in the Find menu"
                    )
                ) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(
                    String(
                        localized: "find.command.find-previous",
                        defaultValue: "Find Previous",
                        comment: "Find Previous command in the Find menu"
                    )
                ) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(
                    String(
                        localized: "find.command.use-selection-for-find",
                        defaultValue: "Use Selection for Find",
                        comment: "Use Selection for Find command in the Find menu"
                    )
                ) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(
                    String(
                        localized: "find.command.jump-to-selection",
                        defaultValue: "Jump to Selection",
                        comment: "Jump to Selection command in the Find menu"
                    )
                ) {
                    NSApp.sendAction(#selector(NSTextView.centerSelectionInVisibleArea(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("j")
            }
            .disabled(!hasResponder)
        }
    }

    func send(_ action: NSFindPanelAction) {
        let item = NSMenuItem()
        item.tag = Int(action.rawValue)
        responder?.perform(Self.selector, with: item)
    }
}
