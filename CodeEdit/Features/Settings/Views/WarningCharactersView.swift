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
                    Text(String(
                        localized: "settings.warning-characters.description",
                        defaultValue: "CodeEdit can help identify invisible or ambiguous characters, such as zero-width spaces, directional quotes, and more. These will appear with a red block highlighting them. You can disable characters or add more here.",
                        comment: "Warning characters description"
                    ))
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "common.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
