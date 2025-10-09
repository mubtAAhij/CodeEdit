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
        CommandMenu(String(localized: "find_menu.title", comment: "Title for Find menu")) {
            Group {
                Button(String(localized: "find_menu.find", comment: "Find menu item")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "find_menu.find_and_replace", comment: "Find and Replace menu item")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "find_menu.find_next", comment: "Find Next menu item")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "find_menu.find_previous", comment: "Find Previous menu item")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "find_menu.use_selection_for_find", comment: "Use Selection for Find menu item")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "find_menu.jump_to_selection", comment: "Jump to Selection menu item")) {
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
