//
//  InvisiblesSettingsView.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/13/25.
//

import SwiftUI

struct InvisiblesSettingsView: View {
    typealias Config = SettingsData.TextEditingSettings.InvisibleCharactersConfig

    @Binding var invisibleCharacters: Config

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    VStack {
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text("Show Spaces", comment: "Toggle label") }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text("Default: \(Config.default.spaceReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render spaces", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text("Show Tabs", comment: "Toggle label") }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text("Default: \(Config.default.tabReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render tabs", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text("Show Line Endings", comment: "Toggle label") }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text("Default: \(Config.default.lineFeedReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render line feeds (\\n)", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text("Default: \(Config.default.carriageReturnReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render carriage returns (Microsoft-style line endings)", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.paragraphSeparatorReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render paragraph separators", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.lineSeparatorReplacement)", comment: "Placeholder text")
                            ) {
                                Text("Character used to render line separators", comment: "Label text")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text("Invisible Characters", comment: "Section header")
                    Text("Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description")
                }
                .textFieldStyle(.roundedBorder)
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Done", comment: "Button text")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
