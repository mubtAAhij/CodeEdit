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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Show spaces toggle")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.space-default", defaultValue: "Default: %@", comment: "Default space replacement prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.space-char", defaultValue: "Character used to render spaces", comment: "Space character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Show tabs toggle")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.tab-default", defaultValue: "Default: %@", comment: "Default tab replacement prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tab-char", defaultValue: "Character used to render tabs", comment: "Tab character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Show line endings toggle")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.linefeed-default", defaultValue: "Default: %@", comment: "Default line feed replacement prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.linefeed-char", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.cr-default", defaultValue: "Default: %@", comment: "Default carriage return replacement prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.cr-char", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.para-default", defaultValue: "Default: %@", comment: "Default paragraph separator replacement prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.para-char", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.linesep-default", defaultValue: "Default: %@", comment: "Default line separator replacement prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.linesep-char", defaultValue: "Character used to render line separators", comment: "Line separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.header", defaultValue: "Invisible Characters", comment: "Invisible characters section header"))
                    Text(String(localized: "settings.text-editing.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters section description"))
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
                    Text(String(localized: "settings.text-editing.invisibles.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
