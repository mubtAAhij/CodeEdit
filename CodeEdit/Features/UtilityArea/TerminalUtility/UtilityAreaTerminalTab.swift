//
//  UtilityAreaTerminalTab.swift
//  CodeEdit
//
//  Created by Austin Condiff on 5/26/23.
//

import SwiftUI

struct UtilityAreaTerminalTab: View {
    @ObservedObject var terminal: UtilityAreaTerminal

    var removeTerminals: (_ ids: Set<UUID>) -> Void

    var isSelected: Bool

    var selectedIDs: Set<UUID>

    @FocusState private var isFocused: Bool

    var body: some View {
        let terminalTitle = Binding<String>(
            get: {
                self.terminal.title
            }, set: {
                if $0.trimmingCharacters(in: .whitespaces) == "" && !isFocused {
                    self.terminal.title = self.terminal.terminalTitle
                    self.terminal.customTitle = false
                } else {
                    self.terminal.title = $0
                    self.terminal.customTitle = true
                }
            }
        )

        Label {
            if #available(macOS 14, *) {
                // Fix the icon misplacement issue introduced since macOS 14
                TextField(String(localized: "terminal.name", defaultValue: "Name", comment: "Terminal name field"), text: terminalTitle)
                    .focused($isFocused)
            } else {
                // A padding is needed for macOS 13
                TextField(String(localized: "terminal.name", defaultValue: "Name", comment: "Terminal name field"), text: terminalTitle)
                    .focused($isFocused)
                    .padding(.leading, -8)
            }
        } icon: {
            Image(systemName: "terminal")
        }
        .contextMenu {
            Button(String(localized: "terminal.rename", defaultValue: "Rename...", comment: "Rename terminal")) {
                isFocused = true
            }

            if selectedIDs.contains(terminal.id) && selectedIDs.count > 1 {
                Button(String(localized: "terminal.kill-terminals", defaultValue: "Kill Terminals", comment: "Kill multiple terminals")) {
                    removeTerminals(selectedIDs)
                }
            } else {
                Button(String(localized: "terminal.kill-terminal", defaultValue: "Kill Terminal", comment: "Kill single terminal")) {
                    removeTerminals([terminal.id])
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(terminalTitle.wrappedValue)
        .accessibilityIdentifier("terminalTab")
    }
}
