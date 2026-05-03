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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.text_editing.invisibles.show_spaces", defaultValue: "Show Spaces", comment: "Toggle to show space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.space_char_description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.text_editing.invisibles.show_tabs", defaultValue: "Show Tabs", comment: "Toggle to show tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.tab_char_description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.text_editing.invisibles.show_line_endings", defaultValue: "Show Line Endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.line_feed_description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.carriage_return_description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.paragraph_separator_description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text_editing.invisibles.default_format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text_editing.invisibles.line_separator_description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text_editing.invisibles.header", defaultValue: "Invisible Characters", comment: "Section header for invisible characters settings"))
                    Text(String(localized: "settings.text_editing.invisibles.header_description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters settings section"))
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
                    Text(String(localized: "settings.text_editing.invisibles.done", defaultValue: "Done", comment: "Done button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
