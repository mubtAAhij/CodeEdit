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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.space.default", defaultValue: "Default: %@", comment: "Default character for space replacement"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles.space.description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.tab.default", defaultValue: "Default: %@", comment: "Default character for tab replacement"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles.tab.description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.linefeed.default", defaultValue: "Default: %@", comment: "Default character for line feed replacement"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles.linefeed.description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.carriage-return.default", defaultValue: "Default: %@", comment: "Default character for carriage return replacement"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles.carriage-return.description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.paragraph-separator.default", defaultValue: "Default: %@", comment: "Default character for paragraph separator replacement"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.paragraph-separator.description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.line-separator.default", defaultValue: "Default: %@", comment: "Default character for line separator replacement"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.line-separator.description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.header", defaultValue: "Invisible Characters", comment: "Section header for invisible characters settings"))
                    Text(String(localized: "invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description for invisible characters section"))
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
                    Text(String(localized: "invisibles.done", defaultValue: "Done", comment: "Button to dismiss invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
