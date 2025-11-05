//
//  InvisibleCharacterWarningList.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/13/25.
//

import SwiftUI

struct InvisibleCharacterWarningList: View {
    @Binding var items: [UInt16: String]

    @State private var selection: String?

    var body: some View {
        KeyValueTable(
            items: Binding(
                get: {
                    items.reduce(into: [String: String]()) { dict, keyVal in
                        let hex = String(keyVal.key, radix: 16).uppercased()
                        let padding = String(repeating: "0", count: 4 - hex.count)
                        dict["U+" + padding + hex] = keyVal.value
                    }
                },
                set: { dict in
                    items = dict.reduce(into: [UInt16: String]()) { dict, keyVal in
                        guard let intFromHex = UInt(hexString: String(keyVal.key.trimmingPrefix("U+"))),
                              intFromHex < UInt16.max else {
                            return
                        }
                        let charCode = UInt16(intFromHex)
                        dict[charCode] = keyVal.value
                    }
                }
            ),
            keyColumnName: String(localized: "settings.invisible-characters.unicode-column", defaultValue: "Unicode Character Code", comment: "Column name for unicode character codes"),
            valueColumnName: String(localized: "settings.invisible-characters.notes-column", defaultValue: "Notes", comment: "Column name for notes about invisible characters"),
            newItemInstruction: String(localized: "settings.invisible-characters.add-instruction", defaultValue: "Add A Character As A Hexidecimal Unicode Value", comment: "Instruction for adding a new invisible character warning"),
            actionBarTrailing: {
                Button {
                    // Add defaults without removing user's data. We do still override notes here.
                    items = items.merging(
                        SettingsData.TextEditingSettings.WarningCharacters.default.characters,
                        uniquingKeysWith: { _, defaults in
                            defaults
                        }
                    )
                } label: {
                    Text(String(localized: "settings.invisible-characters.restore-defaults", defaultValue: "Restore Defaults", comment: "Button to restore default invisible character warnings"))
                }
                .buttonStyle(PlainButtonStyle())
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.trailing, 4)
            }
        )
        .frame(minHeight: 96, maxHeight: .infinity)
        .overlay {
            if items.isEmpty {
                Text(String(localized: "settings.invisible-characters.no-warnings", defaultValue: "No warning characters", comment: "Message shown when no invisible character warnings are configured"))
                    .foregroundStyle(Color(.secondaryLabelColor))
            }
        }
    }
}
