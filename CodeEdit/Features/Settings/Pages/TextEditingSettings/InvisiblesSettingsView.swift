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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle to show spaces")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.space-default", defaultValue: "Default: %@", comment: "Default space replacement character"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles.space-help", defaultValue: "Character used to render spaces", comment: "Help text for space replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle to show tabs")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.tab-default", defaultValue: "Default: %@", comment: "Default tab replacement character"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles.tab-help", defaultValue: "Character used to render tabs", comment: "Help text for tab replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle to show line endings")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.linefeed-default", defaultValue: "Default: %@", comment: "Default line feed replacement character"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles.linefeed-help", defaultValue: "Character used to render line feeds (\\n)", comment: "Help text for line feed replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.cr-default", defaultValue: "Default: %@", comment: "Default carriage return replacement character"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles.cr-help", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Help text for carriage return replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.paragraph-default", defaultValue: "Default: %@", comment: "Default paragraph separator replacement character"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.paragraph-help", defaultValue: "Character used to render paragraph separators", comment: "Help text for paragraph separator replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.line-separator-default", defaultValue: "Default: %@", comment: "Default line separator replacement character"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.line-separator-help", defaultValue: "Character used to render line separators", comment: "Help text for line separator replacement field"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.header", defaultValue: "Invisible Characters", comment: "Section header for invisible characters"))
                    Text(String(localized: "invisibles.header-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Section description for invisible characters"))
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
                    Text(String(localized: "invisibles.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
