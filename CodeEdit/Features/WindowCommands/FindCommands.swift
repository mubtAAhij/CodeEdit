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
        CommandMenu(String(localized: "find", comment: "Find menu item")) {
            Group {
                Button(String(localized: "find_ellipsis", comment: "Find menu item with ellipsis")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "find_and_replace_ellipsis", comment: "Find and replace menu item")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "find_next", comment: "Find next menu item")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "find_previous", comment: "Find previous menu item")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "use_selection_for_find", comment: "Use selection for find menu item")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "jump_to_selection", comment: "Jump to selection menu item")) {
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
