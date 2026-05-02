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
        CommandMenu(String(localized: "find.menu.title", defaultValue: "Find", comment: "Find menu title")) {
            Group {
                Button(String(localized: "find.menu.find", defaultValue: "Find...", comment: "Find menu item")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.find.key", defaultValue: "f", comment: "Find menu keyboard shortcut key"))))

                Button(String(localized: "find.menu.replace", defaultValue: "Find and Replace...", comment: "Find and replace menu item")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.replace.key", defaultValue: "f", comment: "Find and replace keyboard shortcut key"))), modifiers: [.option, .command])

                Button(String(localized: "find.menu.next", defaultValue: "Find Next", comment: "Find next menu item")) {
                    send(.next)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.next.key", defaultValue: "g", comment: "Find next keyboard shortcut key"))))

                Button(String(localized: "find.menu.previous", defaultValue: "Find Previous", comment: "Find previous menu item")) {
                    send(.previous)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.previous.key", defaultValue: "g", comment: "Find previous keyboard shortcut key"))), modifiers: [.shift, .command])

                Button(String(localized: "find.menu.use.selection", defaultValue: "Use Selection for Find", comment: "Use selection for find menu item")) {
                    send(.setFindString)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.use.selection.key", defaultValue: "e", comment: "Use selection for find keyboard shortcut key"))))

                Button(String(localized: "find.menu.jump.to.selection", defaultValue: "Jump to Selection", comment: "Jump to selection menu item")) {
                    NSApp.sendAction(#selector(NSTextView.centerSelectionInVisibleArea(_:)), to: nil, from: nil)
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "find.menu.jump.to.selection.key", defaultValue: "j", comment: "Jump to selection keyboard shortcut key"))))
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
