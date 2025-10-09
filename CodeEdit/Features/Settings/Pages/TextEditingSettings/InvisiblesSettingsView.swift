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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles_settings.show_spaces", comment: "Toggle label for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text("Default: \(Config.default.spaceReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.space_character_description", comment: "Description for space character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles_settings.show_tabs", comment: "Toggle label for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text("Default: \(Config.default.tabReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.tab_character_description", comment: "Description for tab character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles_settings.show_line_endings", comment: "Toggle label for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text("Default: \(Config.default.lineFeedReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.line_feed_character_description", comment: "Description for line feed character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text("Default: \(Config.default.carriageReturnReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.carriage_return_character_description", comment: "Description for carriage return character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.paragraphSeparatorReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.paragraph_separator_character_description", comment: "Description for paragraph separator character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.lineSeparatorReplacement)")
                            ) {
                                Text(String(localized: "invisibles_settings.line_separator_character_description", comment: "Description for line separator character text field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles_settings.section_title", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "invisibles_settings.section_description", comment: "Description for invisible characters settings section"))
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
                    Text(String(localized: "common.done", comment: "Done button label"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
