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
                        String(localized: "warning_characters.description", comment: "Description of warning characters feature")
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
                    Text(String(localized: "action.done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
