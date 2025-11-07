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
        CommandMenu(String(
            localized: "find-commands.menu",
            defaultValue: "Find",
            comment: "Find menu title"
        )) {
            Group {
                Button(String(
                    localized: "find-commands.find",
                    defaultValue: "Find...",
                    comment: "Menu item to open find panel"
                )) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(
                    localized: "find-commands.find-and-replace",
                    defaultValue: "Find and Replace...",
                    comment: "Menu item to open find and replace panel"
                )) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(
                    localized: "find-commands.find-next",
                    defaultValue: "Find Next",
                    comment: "Menu item to find next occurrence"
                )) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(
                    localized: "find-commands.find-previous",
                    defaultValue: "Find Previous",
                    comment: "Menu item to find previous occurrence"
                )) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(
                    localized: "find-commands.use-selection",
                    defaultValue: "Use Selection for Find",
                    comment: "Menu item to use selected text as find term"
                )) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(
                    localized: "find-commands.jump-to-selection",
                    defaultValue: "Jump to Selection",
                    comment: "Menu item to scroll to selected text"
                )) {
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
