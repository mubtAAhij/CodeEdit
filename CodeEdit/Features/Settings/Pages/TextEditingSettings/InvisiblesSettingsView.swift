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
                        Toggle(isOn: $invisibleCharacters.showSpaces) {
                            Text(String(localized: "settings.text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle label for showing spaces"))
                        }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.space-character", defaultValue: "Character used to render spaces", comment: "Description of space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) {
                            Text(String(localized: "settings.text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle label for showing tabs"))
                        }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tab-character", defaultValue: "Character used to render tabs", comment: "Description of tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) {
                            Text(String(localized: "settings.text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle label for showing line endings"))
                        }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feed-character", defaultValue: "Character used to render line feeds (\\n)", comment: "Description of line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-return-character", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description of carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separator-character", defaultValue: "Character used to render paragraph separators", comment: "Description of paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.default-prompt", defaultValue: "Default: %@", comment: "Prompt showing default character replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separator-character", defaultValue: "Character used to render line separators", comment: "Description of line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.section-title", defaultValue: "Invisible Characters", comment: "Section header for invisible characters settings"))
                    Text(String(localized: "settings.text-editing.invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description for invisible characters settings"))
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
                    Text(String(localized: "settings.text-editing.invisibles.done", defaultValue: "Done", comment: "Button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
