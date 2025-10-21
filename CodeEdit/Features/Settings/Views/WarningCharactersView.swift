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
                    Text(String(localized: "settings.warningCharactersDescription", comment: "Settings description"))
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "settings.done", comment: "Button text"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
