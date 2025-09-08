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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "show_spaces", comment: "Toggle label for showing spaces in invisible characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "default_space_replacement", comment: "Placeholder text showing default space replacement character"))
                            ) {
                                Text(String(localized: "space_character_description", comment: "Description for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "show_tabs", comment: "Toggle label for showing tabs in invisible characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "default_tab_replacement", comment: "Placeholder text showing default tab replacement character"))
                            ) {
                                Text(String(localized: "tab_character_description", comment: "Description for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "show_line_endings", comment: "Toggle label for showing line endings in invisible characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "default_line_feed_replacement", comment: "Placeholder text showing default line feed replacement character"))
                            ) {
                                Text(String(localized: "line_feed_character_description", comment: "Description for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "default_carriage_return_replacement", comment: "Placeholder text showing default carriage return replacement character"))
                            ) {
                                Text(String(localized: "carriage_return_character_description", comment: "Description for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "default_paragraph_separator_replacement", comment: "Placeholder text showing default paragraph separator replacement character"))
                            ) {
                                Text(String(localized: "paragraph_separator_character_description", comment: "Description for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(localized: "default_line_separator_replacement", comment: "Placeholder text showing default line separator replacement character"))
                            ) {
                                Text(String(localized: "line_separator_character_description", comment: "Description for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisible_characters", comment: "Header for invisible characters settings section"))
                    Text(String(localized: "invisible_characters_description", comment: "Description for invisible characters settings section"))
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
                    Text(String(localized: "done", comment: "Button label to close dialog"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
