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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.settings.show.spaces", defaultValue: "Show Spaces", comment: "Toggle label for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.space.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for spaces"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.space.character.description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.settings.show.tabs", defaultValue: "Show Tabs", comment: "Toggle label for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.tab.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for tabs"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.tab.character.description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.settings.show.line.endings", defaultValue: "Show Line Endings", comment: "Toggle label for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.line.feed.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for line feeds"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.line.feed.character.description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.carriage.return.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for carriage returns"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.carriage.return.character.description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.paragraph.separator.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for paragraph separators"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.paragraph.separator.character.description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.settings.line.separator.default.format", defaultValue: "Default: %@", comment: "Prompt showing default character for line separators"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.settings.line.separator.character.description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.settings.header.title", defaultValue: "Invisible Characters", comment: "Header title for invisible characters settings section"))
                    Text(String(localized: "invisibles.settings.header.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Header description for invisible characters settings section"))
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
                    Text(String(localized: "invisibles.settings.done.button", defaultValue: "Done", comment: "Done button label to dismiss invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
