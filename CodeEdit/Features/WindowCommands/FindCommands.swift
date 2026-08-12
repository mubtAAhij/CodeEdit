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
        CommandMenu(String(localized: "windowcommands.find.title", defaultValue: "Find", comment: "Top-level title for the Find commands menu")) {
            Group {
                Button(String(localized: "windowcommands.find.find", defaultValue: "Find...", comment: "Menu item title to open the find panel")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "windowcommands.find.find-and-replace", defaultValue: "Find and Replace...", comment: "Menu item title to open find and replace")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "windowcommands.find.find-next", defaultValue: "Find Next", comment: "Menu item title to jump to the next find match")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "windowcommands.find.find-previous", defaultValue: "Find Previous", comment: "Menu item title to jump to the previous find match")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "windowcommands.find.use-selection-for-find", defaultValue: "Use Selection for Find", comment: "Menu item title to use selected text as the find query")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "windowcommands.find.jump-to-selection", defaultValue: "Jump to Selection", comment: "Menu item title to jump to the currently selected text")) {
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
