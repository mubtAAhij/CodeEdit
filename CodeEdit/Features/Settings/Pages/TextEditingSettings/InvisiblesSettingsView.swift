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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles-settings.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show spaces")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.space-char-description", defaultValue: "Character used to render spaces", comment: "Description for space character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles-settings.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tabs")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.tab-char-description", defaultValue: "Character used to render tabs", comment: "Description for tab character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles-settings.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line endings")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.line-feed-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.carriage-return-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.paragraph-separator-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default_colon", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.line-separator-description", defaultValue: "Character used to render line separators", comment: "Description for line separator character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles-settings.title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "invisibles-settings.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters settings"))
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
                    Text(String(localized: "invisibles-settings.done", defaultValue: "Done", comment: "Button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
