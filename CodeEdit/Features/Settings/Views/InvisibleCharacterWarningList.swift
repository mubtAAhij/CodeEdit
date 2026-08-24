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
                              intFromHex < UInt16.max
                        else {
                            return
                        }
                        let charCode = UInt16(intFromHex)
                        dict[charCode] = keyVal.value
                    }
                }
            ),
            keyColumnName: String(localized: "settings.invisible-characters.unicode-character-code", defaultValue: "Unicode Character Code", comment: "Column title for unicode character code in invisible character warning list"),
            valueColumnName: String(localized: "settings.invisible-characters.notes", defaultValue: "Notes", comment: "Column title for notes in invisible character warning list"),
            newItemInstruction: String(localized: "settings.invisible-characters.add-character-hex-unicode", defaultValue: "Add A Character As A Hexidecimal Unicode Value", comment: "Instructional text for adding a warning character by hexadecimal unicode value"),
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
                    Text(String(localized: "settings.invisible-characters.restore-defaults", defaultValue: "Restore Defaults", comment: "Button title to restore default invisible character warning set"))
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
                Text(String(localized: "settings.invisible-characters.no-warning-characters", defaultValue: "No warning characters", comment: "Empty state text when no warning characters are configured"))
                    .foregroundStyle(Color(.secondaryLabelColor))
            }
        }
    }
}
