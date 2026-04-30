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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle label for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.space-character-description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle label for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.tab-character-description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle label for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-feed-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.carriage-return-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.paragraph-separator-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-format", defaultValue: "Default: %@", comment: "Default value format for invisible character replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-separator-description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "text-editing.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "text-editing.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description for invisible characters settings"))
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
                    Text(String(localized: "text-editing.invisibles.done", defaultValue: "Done", comment: "Done button to dismiss invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
