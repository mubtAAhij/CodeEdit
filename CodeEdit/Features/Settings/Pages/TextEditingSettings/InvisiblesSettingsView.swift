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
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.space-character", defaultValue: "Character used to render spaces", comment: "Label for space replacement character"))
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
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tab-character", defaultValue: "Character used to render tabs", comment: "Label for tab replacement character"))
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
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Label for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Label for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Label for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Default value prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separator-character", defaultValue: "Character used to render line separators", comment: "Label for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "settings.text-editing.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description for invisible characters settings"))
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
