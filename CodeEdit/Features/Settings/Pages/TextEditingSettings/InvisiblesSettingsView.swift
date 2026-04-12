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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle for showing spaces")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-space-replacement", defaultValue: "Default: %@", comment: "Placeholder for default space replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.space-character-description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle for showing tabs")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-tab-replacement", defaultValue: "Default: %@", comment: "Placeholder for default tab replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.tab-character-description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle for showing line endings")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-feed-replacement", defaultValue: "Default: %@", comment: "Placeholder for default line feed replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-feed-character-description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-carriage-return-replacement", defaultValue: "Default: %@", comment: "Placeholder for default carriage return replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.carriage-return-character-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-paragraph-separator-replacement", defaultValue: "Default: %@", comment: "Placeholder for default paragraph separator replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.paragraph-separator-character-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-separator-replacement", defaultValue: "Default: %@", comment: "Placeholder for default line separator replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-separator-character-description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "text-editing.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "text-editing.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters settings"))
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
