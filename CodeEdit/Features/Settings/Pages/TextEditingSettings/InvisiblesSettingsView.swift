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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Show spaces toggle")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.space-default", defaultValue: "Default: %@", comment: "Space replacement default"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles.space-character", defaultValue: "Character used to render spaces", comment: "Space character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Show tabs toggle")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.tab-default", defaultValue: "Default: %@", comment: "Tab replacement default"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles.tab-character", defaultValue: "Character used to render tabs", comment: "Tab character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Show line endings toggle")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.linefeed-default", defaultValue: "Default: %@", comment: "Line feed replacement default"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles.linefeed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.carriage-return-default", defaultValue: "Default: %@", comment: "Carriage return replacement default"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.paragraph-separator-default", defaultValue: "Default: %@", comment: "Paragraph separator replacement default"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.line-separator-default", defaultValue: "Default: %@", comment: "Line separator replacement default"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.line-separator-character", defaultValue: "Character used to render line separators", comment: "Line separator character description"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.title", defaultValue: "Invisible Characters", comment: "Invisible characters section title"))
                    Text(String(localized: "invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters description"))
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
                    Text(String(localized: "invisibles.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
