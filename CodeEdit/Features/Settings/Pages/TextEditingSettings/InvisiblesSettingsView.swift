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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Show spaces toggle")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-space", defaultValue: "Default: %@", comment: "Default space replacement placeholder"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.space-character", defaultValue: "Character used to render spaces", comment: "Space character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Show tabs toggle")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-tab", defaultValue: "Default: %@", comment: "Default tab replacement placeholder"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.tab-character", defaultValue: "Character used to render tabs", comment: "Tab character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Show line endings toggle")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-feed", defaultValue: "Default: %@", comment: "Default line feed replacement placeholder"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-feed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-carriage-return", defaultValue: "Default: %@", comment: "Default carriage return replacement placeholder"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-paragraph-separator", defaultValue: "Default: %@", comment: "Default paragraph separator replacement placeholder"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-separator", defaultValue: "Default: %@", comment: "Default line separator replacement placeholder"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-separator-character", defaultValue: "Character used to render line separators", comment: "Line separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "text-editing.invisibles.header", defaultValue: "Invisible Characters", comment: "Invisible characters section header"))
                    Text(String(localized: "text-editing.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters section description"))
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
                    Text(String(localized: "text-editing.invisibles.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
