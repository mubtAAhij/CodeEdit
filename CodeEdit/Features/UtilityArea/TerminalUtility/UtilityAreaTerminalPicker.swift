//
//  UtilityAreaTerminalPicker.swift
//  CodeEdit
//
//  Created by Khan Winter on 1/6/25.
//

import SwiftUI

struct UtilityAreaTerminalPicker: View {
    @Binding var selectedIDs: Set<UUID>
    var terminals: [UtilityAreaTerminal]

    var selectedID: Binding<UUID?> {
        Binding<UUID?>(
            get: {
                selectedIDs.first
            },
            set: { newValue in
                if let selectedID = newValue {
                    selectedIDs = [selectedID]
                }
            }
        )
    }

    var body: some View {
        Picker(String(localized: "utility-area.terminal-picker.terminal-tab", defaultValue: "Terminal Tab", comment: "Label for a terminal tab entry in utility area terminal picker"), selection: selectedID) {
            ForEach(terminals, id: \.self.id) { terminal in
                Text(terminal.title)
                    .tag(terminal.id)
            }

            if terminals.isEmpty {
                Text(String(localized: "utility-area.terminal-picker.no-open-terminals", defaultValue: "No Open Terminals", comment: "Empty state text when no terminals are open"))
            }
        }
        .labelsHidden()
        .controlSize(.small)
        .buttonStyle(.borderless)
    }
}
