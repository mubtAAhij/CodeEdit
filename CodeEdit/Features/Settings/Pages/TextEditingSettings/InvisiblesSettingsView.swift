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
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.spaces-render-description", defaultValue: "Character used to render spaces", comment: "Description for space character replacement field"))
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
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tabs-render-description", defaultValue: "Character used to render tabs", comment: "Description for tab character replacement field"))
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
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feeds-render-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed character replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-returns-render-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return character replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separators-render-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator character replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt for invisible character replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separators-render-description", defaultValue: "Character used to render line separators", comment: "Description for line separator character replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section title for invisible character settings"))
                    Text(String(localized: "settings.text-editing.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description for invisible character settings"))
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
                    Text(String(localized: "settings.text-editing.invisibles.done-button", defaultValue: "Done", comment: "Button to dismiss the invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
