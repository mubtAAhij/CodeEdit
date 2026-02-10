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
        CommandMenu(String(localized: "menu.find", defaultValue: "Find", comment: "Find menu")) {
            Group {
                Button(String(localized: "menu.find.find", defaultValue: "Find...", comment: "Find command")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "menu.find.find-replace", defaultValue: "Find and Replace...", comment: "Find and replace command")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "menu.find.next", defaultValue: "Find Next", comment: "Find next command")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "menu.find.previous", defaultValue: "Find Previous", comment: "Find previous command")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "menu.find.use-selection", defaultValue: "Use Selection for Find", comment: "Use selection for find command")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "menu.find.jump-to-selection", defaultValue: "Jump to Selection", comment: "Jump to selection command")) {
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
