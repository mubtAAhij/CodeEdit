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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.invisibles.show-spaces-toggle", defaultValue: "Show Spaces", comment: "Toggle to show spaces")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "settings.invisibles.space-default-prompt", defaultValue: "Default: \(Config.default.spaceReplacement)", comment: "Prompt showing default space character"))
                            ) {
                                Text(String(localized: "settings.invisibles.space-character-label", defaultValue: "Character used to render spaces", comment: "Label for space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.invisibles.show-tabs-toggle", defaultValue: "Show Tabs", comment: "Toggle to show tabs")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "settings.invisibles.tab-default-prompt", defaultValue: "Default: \(Config.default.tabReplacement)", comment: "Prompt showing default tab character"))
                            ) {
                                Text(String(localized: "settings.invisibles.tab-character-label", defaultValue: "Character used to render tabs", comment: "Label for tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.invisibles.show-line-endings-toggle", defaultValue: "Show Line Endings", comment: "Toggle to show line endings")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "settings.invisibles.line-feed-default-prompt", defaultValue: "Default: \(Config.default.lineFeedReplacement)", comment: "Prompt showing default line feed character"))
                            ) {
                                Text(String(localized: "settings.invisibles.line-feed-character-label", defaultValue: "Character used to render line feeds (\\n)", comment: "Label for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "settings.invisibles.carriage-return-default-prompt", defaultValue: "Default: \(Config.default.carriageReturnReplacement)", comment: "Prompt showing default carriage return character"))
                            ) {
                                Text(String(localized: "settings.invisibles.carriage-return-character-label", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Label for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "settings.invisibles.paragraph-separator-default-prompt", defaultValue: "Default: \(Config.default.paragraphSeparatorReplacement)", comment: "Prompt showing default paragraph separator character"))
                            ) {
                                Text(String(localized: "settings.invisibles.paragraph-separator-character-label", defaultValue: "Character used to render paragraph separators", comment: "Label for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(localized: "settings.invisibles.line-separator-default-prompt", defaultValue: "Default: \(Config.default.lineSeparatorReplacement)", comment: "Prompt showing default line separator character"))
                            ) {
                                Text(String(localized: "settings.invisibles.line-separator-character-label", defaultValue: "Character used to render line separators", comment: "Label for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters"))
                    Text(String(localized: "settings.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters section"))
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
                    Text(String(localized: "button.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
