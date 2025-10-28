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
        CommandMenu("find.menu", comment: "Find menu") {
            Group {
                Button("find.find", comment: "Find button") {
                    send(.showFindPanel)
                }
                .keyboardShortcut("f")

                Button("find.find_and_replace", comment: "Find and replace button") {
                    send(.init(rawValue: 12)!)
                }
                .keyboardShortcut("f", modifiers: [.option, .command])

                Button("find.find_next", comment: "Find next button") {
                    send(.next)
                }
                .keyboardShortcut("g")

                Button("find.find_previous", comment: "Find previous button") {
                    send(.previous)
                }
                .keyboardShortcut("g", modifiers: [.shift, .command])

                Button("find.use_selection", comment: "Use selection for find button") {
                    send(.setFindString)
                }
                .keyboardShortcut("e")

                Button("find.jump_to_selection", comment: "Jump to selection button") {
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
