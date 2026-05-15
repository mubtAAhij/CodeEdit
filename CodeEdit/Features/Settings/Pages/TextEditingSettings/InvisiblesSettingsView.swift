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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show spaces")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.space-default", defaultValue: "Default: %@", comment: "Default space character prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.space-character", defaultValue: "Character used to render spaces", comment: "Space character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tabs")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.tab-default", defaultValue: "Default: %@", comment: "Default tab character prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.tab-character", defaultValue: "Character used to render tabs", comment: "Tab character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line endings")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.linefeed-default", defaultValue: "Default: %@", comment: "Default line feed character prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.linefeed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.carriage-return-default", defaultValue: "Default: %@", comment: "Default carriage return character prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.paragraph-separator-default", defaultValue: "Default: %@", comment: "Default paragraph separator character prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.line-separator-default", defaultValue: "Default: %@", comment: "Default line separator character prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.line-separator-character", defaultValue: "Character used to render line separators", comment: "Line separator character field label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.invisibles.header", defaultValue: "Invisible Characters", comment: "Invisible characters section header"))
                    Text(String(localized: "settings.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters section description"))
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
                    Text(String(localized: "settings.invisibles.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
