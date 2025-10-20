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
        CommandMenu(String(localized: "find.menu", comment: "Menu title")) {
            Group {
                Button(String(localized: "find.find", comment: "Menu item title")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "find.findAndReplace", comment: "Menu item title")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "find.findNext", comment: "Menu item title")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "find.findPrevious", comment: "Menu item title")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "find.useSelectionForFind", comment: "Menu item title")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "find.jumpToSelection", comment: "Menu item title")) {
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
