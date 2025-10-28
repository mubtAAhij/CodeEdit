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
                    Text("settings.warning_characters.description", comment: "Section description")
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("actions.done", comment: "Button label")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
