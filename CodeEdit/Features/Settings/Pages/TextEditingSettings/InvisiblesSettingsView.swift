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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text("invisibles.show_spaces", comment: "Toggle to show spaces") }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text("invisibles.default_space \(Config.default.spaceReplacement)", comment: "Default space character")
                            ) {
                                Text("invisibles.space_help", comment: "Help text for space character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text("invisibles.show_tabs", comment: "Toggle to show tabs") }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text("invisibles.default_tab \(Config.default.tabReplacement)", comment: "Default tab character")
                            ) {
                                Text("invisibles.tab_help", comment: "Help text for tab character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text("invisibles.show_line_endings", comment: "Toggle to show line endings") }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text("invisibles.default_line_feed \(Config.default.lineFeedReplacement)", comment: "Default line feed character")
                            ) {
                                Text("invisibles.line_feed_help", comment: "Help text for line feed character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text("invisibles.default_carriage_return \(Config.default.carriageReturnReplacement)", comment: "Default carriage return character")
                            ) {
                                Text("invisibles.carriage_return_help", comment: "Help text for carriage return character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text("invisibles.default_paragraph_separator \(Config.default.paragraphSeparatorReplacement)", comment: "Default paragraph separator character")
                            ) {
                                Text("invisibles.paragraph_separator_help", comment: "Help text for paragraph separator character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("invisibles.default_line_separator \(Config.default.lineSeparatorReplacement)", comment: "Default line separator character")
                            ) {
                                Text("invisibles.line_separator_help", comment: "Help text for line separator character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text("invisibles.title", comment: "Section title for invisible characters")
                    Text("invisibles.description", comment: "Section description for invisible characters")
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
                    Text("actions.done", comment: "Done button")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
