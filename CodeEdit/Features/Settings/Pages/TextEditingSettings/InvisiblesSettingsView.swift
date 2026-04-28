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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles-settings.show-spaces", defaultValue: "Show Spaces", comment: "Show spaces toggle")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-space", defaultValue: "Default: %@", comment: "Default space replacement prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.space-character", defaultValue: "Character used to render spaces", comment: "Space character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles-settings.show-tabs", defaultValue: "Show Tabs", comment: "Show tabs toggle")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-tab", defaultValue: "Default: %@", comment: "Default tab replacement prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.tab-character", defaultValue: "Character used to render tabs", comment: "Tab character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles-settings.show-line-endings", defaultValue: "Show Line Endings", comment: "Show line endings toggle")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-linefeed", defaultValue: "Default: %@", comment: "Default line feed replacement prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.linefeed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-carriage-return", defaultValue: "Default: %@", comment: "Default carriage return replacement prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-paragraph-separator", defaultValue: "Default: %@", comment: "Default paragraph separator replacement prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-line-separator", defaultValue: "Default: %@", comment: "Default line separator replacement prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.line-separator-character", defaultValue: "Character used to render line separators", comment: "Line separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles-settings.title", defaultValue: "Invisible Characters", comment: "Invisible characters section title"))
                    Text(String(localized: "invisibles-settings.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters description"))
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
                    Text(String(localized: "invisibles-settings.done-button", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
