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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles-settings.show-spaces", defaultValue: "Show Spaces", comment: "Toggle label for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-space", defaultValue: "Default: %@", comment: "Prompt showing default space replacement character"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.space-character-description", defaultValue: "Character used to render spaces", comment: "Description for space replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles-settings.show-tabs", defaultValue: "Show Tabs", comment: "Toggle label for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-tab", defaultValue: "Default: %@", comment: "Prompt showing default tab replacement character"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.tab-character-description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles-settings.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle label for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-line-feed", defaultValue: "Default: %@", comment: "Prompt showing default line feed replacement character"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.line-feed-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-carriage-return", defaultValue: "Default: %@", comment: "Prompt showing default carriage return replacement character"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.carriage-return-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-paragraph-separator", defaultValue: "Default: %@", comment: "Prompt showing default paragraph separator replacement character"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.paragraph-separator-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles-settings.default-line-separator", defaultValue: "Default: %@", comment: "Prompt showing default line separator replacement character"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles-settings.line-separator-description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles-settings.section-header", defaultValue: "Invisible Characters", comment: "Section header for invisible characters settings"))
                    Text(String(localized: "invisibles-settings.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters section"))
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
                    Text(String(localized: "invisibles-settings.done-button", defaultValue: "Done", comment: "Button to dismiss invisibles settings sheet"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
