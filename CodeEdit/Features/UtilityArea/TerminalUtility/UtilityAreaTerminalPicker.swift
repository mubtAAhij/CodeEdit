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
        Picker(String(localized: "terminal.picker.label", comment: "Picker label"), selection: selectedID) {
            ForEach(terminals, id: \.self.id) { terminal in
                Text(terminal.title)
                    .tag(terminal.id)
            }

            if terminals.isEmpty {
                Text(String(localized: "terminal.picker.empty", comment: "Empty state message"))
            }
        }
        .labelsHidden()
        .controlSize(.small)
        .buttonStyle(.borderless)
    }
}
