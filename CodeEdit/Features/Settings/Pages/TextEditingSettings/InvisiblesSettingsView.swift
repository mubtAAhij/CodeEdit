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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "show-spaces", defaultValue: "Show Spaces", comment: "Show spaces toggle label", os_id: "102481")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "default-space-replacement", defaultValue: "Default: %@", comment: "Default space replacement prompt", os_id: "102482"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "character-render-spaces", defaultValue: "Character used to render spaces", comment: "Character used to render spaces label", os_id: "102483"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "show-tabs", defaultValue: "Show Tabs", comment: "Show tabs toggle label", os_id: "102484")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "default-tab-replacement", defaultValue: "Default: %@", comment: "Default tab replacement prompt", os_id: "102485"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "character-render-tabs", defaultValue: "Character used to render tabs", comment: "Character used to render tabs label", os_id: "102486"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "show-line-endings", defaultValue: "Show Line Endings", comment: "Show line endings toggle label", os_id: "102487")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "default-line-feed-replacement", defaultValue: "Default: %@", comment: "Default line feed replacement prompt", os_id: "102488"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "character-render-line-feeds", defaultValue: "Character used to render line feeds (\\n)", comment: "Character used to render line feeds label", os_id: "102489"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "default-carriage-return-replacement", defaultValue: "Default: %@", comment: "Default carriage return replacement prompt", os_id: "102490"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "character-render-carriage-returns", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Character used to render carriage returns label", os_id: "102491"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default-paragraph-separator-replacement", defaultValue: "Default: %@", comment: "Default paragraph separator replacement prompt", os_id: "102492"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "character-render-paragraph-separators", defaultValue: "Character used to render paragraph separators", comment: "Character used to render paragraph separators label", os_id: "102493"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "default-line-separator-replacement", defaultValue: "Default: %@", comment: "Default line separator replacement prompt", os_id: "102494"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "character-render-line-separators", defaultValue: "Character used to render line separators", comment: "Character used to render line separators label", os_id: "102495"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisible-characters", defaultValue: "Invisible Characters", comment: "Invisible characters section header", os_id: "102496"))
                    Text(String(localized: "invisible-characters-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible characters description", os_id: "102497"))
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
                    Text(String(localized: "done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
