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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-space-prompt", defaultValue: "Default: %@", comment: "Prompt showing default space replacement character"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.space-character-label", defaultValue: "Character used to render spaces", comment: "Label for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-tab-prompt", defaultValue: "Default: %@", comment: "Prompt showing default tab replacement character"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.tab-character-label", defaultValue: "Character used to render tabs", comment: "Label for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-feed-prompt", defaultValue: "Default: %@", comment: "Prompt showing default line feed replacement character"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-feed-character-label", defaultValue: "Character used to render line feeds (\\n)", comment: "Label for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-carriage-return-prompt", defaultValue: "Default: %@", comment: "Prompt showing default carriage return replacement character"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.carriage-return-character-label", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Label for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-paragraph-separator-prompt", defaultValue: "Default: %@", comment: "Prompt showing default paragraph separator replacement character"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.paragraph-separator-character-label", defaultValue: "Character used to render paragraph separators", comment: "Label for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "text-editing.invisibles.default-line-separator-prompt", defaultValue: "Default: %@", comment: "Prompt showing default line separator replacement character"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-separator-character-label", defaultValue: "Character used to render line separators", comment: "Label for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "text-editing.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section title for invisible characters settings"))
                    Text(String(localized: "text-editing.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters settings section"))
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
                    Text(String(localized: "text-editing.invisibles.done-button", defaultValue: "Done", comment: "Button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
