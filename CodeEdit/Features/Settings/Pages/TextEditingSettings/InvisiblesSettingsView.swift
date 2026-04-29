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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.spaces-description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tabs-description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feeds-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-returns-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separators-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separators-description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.header", defaultValue: "Invisible Characters", comment: "Section header for invisible character settings"))
                    Text(String(localized: "settings.text-editing.invisibles.header-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible character settings section"))
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
                    Text(String(localized: "settings.text-editing.invisibles.done", defaultValue: "Done", comment: "Button to close invisibles settings sheet"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
