//
//  WarningCharactersView.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/16/25.
//

import SwiftUI

struct WarningCharactersView: View {
    typealias Config = SettingsData.TextEditingSettings.WarningCharacters

    @Binding var warningCharacters: Config

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    InvisibleCharacterWarningList(items: $warningCharacters.characters)
                } header: {
                    Text("Warning Characters")
                    Text(
                        String(localized: "warning_characters_description_part1", comment: "First part of warning characters description") +
                        String(localized: "warning_characters_description_part2", comment: "Second part of warning characters description") +
                        "String(localized: "warning_characters_description_suffix", comment: "Description suffix for warning characters settings")"
                    )
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "done", comment: "Done button text"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
