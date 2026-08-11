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
        CommandMenu(String(localized: "window-commands.find.title", defaultValue: "Find", comment: "Top-level Find menu title in window commands")) {
            Group {
                Button(String(localized: "window-commands.find.find", defaultValue: "Find...", comment: "Find menu command to open find panel")) {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button(String(localized: "window-commands.find.find-and-replace", defaultValue: "Find and Replace...", comment: "Find menu command to open find and replace panel")) {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button(String(localized: "window-commands.find.find-next", defaultValue: "Find Next", comment: "Find menu command to jump to next match")) {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button(String(localized: "window-commands.find.find-previous", defaultValue: "Find Previous", comment: "Find menu command to jump to previous match")) {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button(String(localized: "window-commands.find.use-selection-for-find", defaultValue: "Use Selection for Find", comment: "Find menu command to use selected text for find")) {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button(String(localized: "window-commands.find.jump-to-selection", defaultValue: "Jump to Selection", comment: "Find menu command to jump to current selection")) {
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
