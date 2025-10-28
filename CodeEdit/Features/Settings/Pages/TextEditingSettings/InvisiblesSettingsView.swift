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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text("settings.invisibles.show_spaces", comment: "Toggle to show space characters") }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text("settings.invisibles.default_space \(Config.default.spaceReplacement)", comment: "Default space replacement character")
                            ) {
                                Text("settings.invisibles.space_character_help", comment: "Help text for space replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text("settings.invisibles.show_tabs", comment: "Toggle to show tab characters") }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text("settings.invisibles.default_tab \(Config.default.tabReplacement)", comment: "Default tab replacement character")
                            ) {
                                Text("settings.invisibles.tab_character_help", comment: "Help text for tab replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text("settings.invisibles.show_line_endings", comment: "Toggle to show line ending characters") }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text("settings.invisibles.default_line_feed \(Config.default.lineFeedReplacement)", comment: "Default line feed replacement character")
                            ) {
                                Text("settings.invisibles.line_feed_help", comment: "Help text for line feed replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text("settings.invisibles.default_carriage_return \(Config.default.carriageReturnReplacement)", comment: "Default carriage return replacement character")
                            ) {
                                Text("settings.invisibles.carriage_return_help", comment: "Help text for carriage return replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text("settings.invisibles.default_paragraph_separator \(Config.default.paragraphSeparatorReplacement)", comment: "Default paragraph separator replacement character")
                            ) {
                                Text("settings.invisibles.paragraph_separator_help", comment: "Help text for paragraph separator replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("settings.invisibles.default_line_separator \(Config.default.lineSeparatorReplacement)", comment: "Default line separator replacement character")
                            ) {
                                Text("settings.invisibles.line_separator_help", comment: "Help text for line separator replacement character")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text("settings.invisibles.title", comment: "Section title for invisible characters settings")
                    Text("settings.invisibles.description", comment: "Description for invisible characters settings")
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
                    Text("actions.done", comment: "Button to close settings")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
