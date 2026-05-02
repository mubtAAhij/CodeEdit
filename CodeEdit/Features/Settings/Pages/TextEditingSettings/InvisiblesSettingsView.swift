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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show invisible space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.space-default", defaultValue: "Default: %@", comment: "Default space replacement character prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.space-label", defaultValue: "Character used to render spaces", comment: "Label for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show invisible tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.tab-default", defaultValue: "Default: %@", comment: "Default tab replacement character prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.tab-label", defaultValue: "Character used to render tabs", comment: "Label for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show invisible line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.line-feed-default", defaultValue: "Default: %@", comment: "Default line feed replacement character prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.line-feed-label", defaultValue: "Character used to render line feeds (\\n)", comment: "Label for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.carriage-return-default", defaultValue: "Default: %@", comment: "Default carriage return replacement character prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.carriage-return-label", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Label for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.paragraph-separator-default", defaultValue: "Default: %@", comment: "Default paragraph separator replacement character prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.paragraph-separator-label", defaultValue: "Character used to render paragraph separators", comment: "Label for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.invisibles.line-separator-default", defaultValue: "Default: %@", comment: "Default line separator replacement character prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "settings.invisibles.line-separator-label", defaultValue: "Character used to render line separators", comment: "Label for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.invisibles.header", defaultValue: "Invisible Characters", comment: "Section header for invisible characters settings"))
                    Text(String(localized: "settings.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters settings"))
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
                    Text(String(localized: "settings.invisibles.done", defaultValue: "Done", comment: "Done button to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
