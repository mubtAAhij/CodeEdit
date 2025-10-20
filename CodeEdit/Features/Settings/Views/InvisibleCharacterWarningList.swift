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
            keyColumnName: String(localized: "settings.warningCharacters.keyColumn", comment: "Column name"),
            valueColumnName: String(localized: "settings.warningCharacters.valueColumn", comment: "Column name"),
            newItemInstruction: String(localized: "settings.warningCharacters.addInstruction", comment: "Instructions"),
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
                    Text(String(localized: "settings.warningCharacters.restoreDefaults", comment: "Button text"))
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
                Text(String(localized: "settings.warningCharacters.empty", comment: "Empty state message"))
                    .foregroundStyle(Color(.secondaryLabelColor))
            }
        }
    }
}
