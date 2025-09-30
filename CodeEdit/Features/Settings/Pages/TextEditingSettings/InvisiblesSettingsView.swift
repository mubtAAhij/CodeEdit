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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text_editing.show_spaces", comment: "Toggle for showing spaces as visible characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "text_editing.default_space_replacement", defaultValue: "Default: \(Config.default.spaceReplacement)", comment: "Placeholder showing default space replacement character"))
                            ) {
                                Text(String(localized: "text_editing.space_character_description", comment: "Description for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text_editing.show_tabs", comment: "Toggle for showing tabs as visible characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "text_editing.default_tab_replacement", defaultValue: "Default: \(Config.default.tabReplacement)", comment: "Placeholder showing default tab replacement character"))
                            ) {
                                Text(String(localized: "text_editing.tab_character_description", comment: "Description for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text_editing.show_line_endings", comment: "Toggle for showing line endings as visible characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "text_editing.default_line_feed_replacement", defaultValue: "Default: \(Config.default.lineFeedReplacement)", comment: "Placeholder showing default line feed replacement character"))
                            ) {
                                Text(String(localized: "text_editing.line_feed_character_description", comment: "Description for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "text_editing.default_carriage_return_replacement", defaultValue: "Default: \(Config.default.carriageReturnReplacement)", comment: "Placeholder showing default carriage return replacement character"))
                            ) {
                                Text(String(localized: "text_editing.carriage_return_character_description", comment: "Description for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "text_editing.default_paragraph_separator_replacement", defaultValue: "Default: \(Config.default.paragraphSeparatorReplacement)", comment: "Placeholder showing default paragraph separator replacement character"))
                            ) {
                                Text(String(localized: "character_render_paragraph_separators", comment: "Label for paragraph separator character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(localized: "default_line_separator_replacement", defaultValue: "Default: \(Config.default.lineSeparatorReplacement)", comment: "Default value for line separator replacement"))
                            ) {
                                Text(String(localized: "character_render_line_separators", comment: "Label for line separator character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisible_characters", comment: "Section header for invisible character settings"))
                    Text(String(localized: "toggle_whitespace_symbols_description", comment: "Description of invisible character settings functionality"))
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
                    Text(String(localized: "done", comment: "Button to close dialog"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
