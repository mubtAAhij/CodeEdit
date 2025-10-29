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
        CommandMenu(String(localized: "Find", comment: "Menu title for Find menu")) {
            Group {
                Button(String(localized: "Find...", comment: "Button to open find panel")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "Find and Replace...", comment: "Button to open find and replace panel")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "Find Next", comment: "Button to find next occurrence")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "Find Previous", comment: "Button to find previous occurrence")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "Use Selection for Find", comment: "Button to use current selection for find")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "Jump to Selection", comment: "Button to jump to current selection")) {
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
