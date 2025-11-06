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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.space-default", defaultValue: "Default: \(Config.default.spaceReplacement)", comment: "Default placeholder for space replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.space-description", defaultValue: "Character used to render spaces", comment: "Description of space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.tab-default", defaultValue: "Default: \(Config.default.tabReplacement)", comment: "Default placeholder for tab replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tab-description", defaultValue: "Character used to render tabs", comment: "Description of tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.line-feed-default", defaultValue: "Default: \(Config.default.lineFeedReplacement)", comment: "Default placeholder for line feed replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feed-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description of line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.carriage-return-default", defaultValue: "Default: \(Config.default.carriageReturnReplacement)", comment: "Default placeholder for carriage return replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-return-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description of carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.paragraph-separator-default", defaultValue: "Default: \(Config.default.paragraphSeparatorReplacement)", comment: "Default placeholder for paragraph separator replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separator-description", defaultValue: "Character used to render paragraph separators", comment: "Description of paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(localized: "settings.text-editing.invisibles.line-separator-default", defaultValue: "Default: \(Config.default.lineSeparatorReplacement)", comment: "Default placeholder for line separator replacement character"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separator-description", defaultValue: "Character used to render line separators", comment: "Description of line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.header", defaultValue: "Invisible Characters", comment: "Header for invisible characters section"))
                    Text(String(localized: "settings.text-editing.invisibles.header-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters section"))
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
                    Text(String(localized: "common.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
