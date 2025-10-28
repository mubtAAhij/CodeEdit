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
        CommandMenu("find.menu", comment: "Find menu title") {
            Group {
                Button("find.find", comment: "Find command") {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button("find.find_replace", comment: "Find and replace command") {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button("find.next", comment: "Find next command") {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button("find.previous", comment: "Find previous command") {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button("find.use_selection", comment: "Use selection for find") {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button("find.jump_to_selection", comment: "Jump to selection") {
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
