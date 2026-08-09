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
        CommandMenu(String(localized: "window-commands.find.menu-title", defaultValue: "Find", comment: "Main menu title for find commands")) {
            Group {
                Button(String(localized: "window-commands.find.find", defaultValue: "Find...", comment: "Menu command title for opening find panel")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "window-commands.find.find-and-replace", defaultValue: "Find and Replace...", comment: "Menu command title for opening find and replace panel")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "window-commands.find.find-next", defaultValue: "Find Next", comment: "Menu command title for finding next match")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "window-commands.find.find-previous", defaultValue: "Find Previous", comment: "Menu command title for finding previous match")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "window-commands.find.use-selection-for-find", defaultValue: "Use Selection for Find", comment: "Menu command title to use current selection as find query")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "window-commands.find.jump-to-selection", defaultValue: "Jump to Selection", comment: "Menu command title to jump to current selection")) {
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
