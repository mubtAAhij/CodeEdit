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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.invisibles.show_spaces", defaultValue: "Show Spaces", comment: "Toggle to show space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.space_character", defaultValue: "Character used to render spaces", comment: "Label for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.invisibles.show_tabs", defaultValue: "Show Tabs", comment: "Toggle to show tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.tab_character", defaultValue: "Character used to render tabs", comment: "Label for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.invisibles.show_line_endings", defaultValue: "Show Line Endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.linefeed_character", defaultValue: "Character used to render line feeds (\\n)", comment: "Label for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.carriage_return_character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Label for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.paragraph_separator_character", defaultValue: "Character used to render paragraph separators", comment: "Label for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.default_format", defaultValue: "Default: %@", comment: "Format string for default character replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.line_separator_character", defaultValue: "Character used to render line separators", comment: "Label for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.invisibles.title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "settings.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description of invisible characters settings"))
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
                    Text(String(localized: "settings.invisibles.done", defaultValue: "Done", comment: "Button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
