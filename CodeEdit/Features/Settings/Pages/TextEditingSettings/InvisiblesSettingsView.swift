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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "show_spaces", comment: "Show spaces toggle label")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "default_space_replacement", arguments: [Config.default.spaceReplacement], comment: "Default space replacement character placeholder"))
                            ) {
                                Text(String(localized: "space_character_description", comment: "Description for space character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "show_tabs", comment: "Show tabs toggle label")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "default_tab_replacement", arguments: [Config.default.tabReplacement], comment: "Default tab replacement character placeholder"))
                            ) {
                                Text(String(localized: "tab_character_description", comment: "Description for tab character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "show_line_endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "default_line_feed_replacement", arguments: [Config.default.lineFeedReplacement], comment: "Default line feed replacement character"))
                            ) {
                                Text(String(localized: "line_feed_character_description", comment: "Description for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "default_carriage_return_replacement", arguments: [Config.default.carriageReturnReplacement], comment: "Default carriage return replacement character"))
                            ) {
                                Text(String(localized: "carriage_return_character_description", comment: "Description for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "default_paragraph_separator_replacement", arguments: [Config.default.paragraphSeparatorReplacement], comment: "Default paragraph separator replacement character"))
                            ) {
                                Text(String(localized: "paragraph_separator_character_description", comment: "Description for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(localized: "default_line_separator_replacement", arguments: [Config.default.lineSeparatorReplacement], comment: "Default line separator replacement character"))
                            ) {
                                Text(String(localized: "line_separator_character_description", comment: "Description for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisible_characters", comment: "Section header for invisible character settings"))
                    Text(String(localized: "invisible_characters_description", comment: "Description for invisible character settings section"))
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
                    Text(String(localized: "done", comment: "Done button text"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
