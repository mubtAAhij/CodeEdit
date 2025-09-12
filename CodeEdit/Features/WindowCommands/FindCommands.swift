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
        CommandMenu(String(localized: "find_menu", comment: "Menu title for find operations")) {
            Group {
                Button(String(localized: "find", comment: "Menu item to open find panel")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "find_and_replace", comment: "Menu item to open find and replace panel")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "find_next", comment: "Menu item to find next occurrence")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "find_previous", comment: "Menu item to find previous occurrence")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "use_selection_for_find", comment: "Menu item to use selected text for find")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "jump_to_selection", comment: "Menu item to jump to current selection")) {
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
