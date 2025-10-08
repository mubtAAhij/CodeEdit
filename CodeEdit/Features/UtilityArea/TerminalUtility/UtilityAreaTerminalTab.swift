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
                TextField(String(localized: "utility_area.terminal.name", comment: "Terminal name label"), text: terminalTitle)
                    .focused($isFocused)
            } else {
                // A padding is needed for macOS 13
                TextField(String(localized: "utility_area.terminal.name", comment: "Terminal name label"), text: terminalTitle)
                    .focused($isFocused)
                    .padding(.leading, -8)
            }
        } icon: {
            Image(systemName: "terminal")
        }
        .contextMenu {
            Button(String(localized: "utility_area.terminal.rename", comment: "Rename terminal menu item")) {
                isFocused = true
            }

            if selectedIDs.contains(terminal.id) && selectedIDs.count > 1 {
                Button(String(localized: "utility_area.terminal.kill_all", comment: "Kill all terminals menu item")) {
                    removeTerminals(selectedIDs)
                }
            } else {
                Button(String(localized: "utility_area.terminal.kill", comment: "Kill terminal menu item")) {
                    removeTerminals([terminal.id])
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(terminalTitle.wrappedValue)
        .accessibilityIdentifier("terminalTab")
    }
}
