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
            keyColumnName: String(localized: "invisible_characters.column.unicode_code", comment: "Column header for Unicode character codes"),
            valueColumnName: String(localized: "invisible_characters.column.notes", comment: "Column header for notes"),
            newItemInstruction: String(localized: "invisible_characters.instruction.add_character", comment: "Instruction for adding a character as hexadecimal Unicode value"),
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
                    Text(String(localized: "invisible_characters.action.restore_defaults", comment: "Button to restore default warning characters"))
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
                Text(String(localized: "invisible_characters.empty_state", comment: "Message when no warning characters are configured"))
                    .foregroundStyle(Color(.secondaryLabelColor))
            }
        }
    }
}
