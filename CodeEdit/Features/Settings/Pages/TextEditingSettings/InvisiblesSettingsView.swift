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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Show Spaces toggle")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.spaceReplacement))
                            ) {
                                Text(String(localized: "invisibles.space-replacement-label", defaultValue: "Character used to render spaces", comment: "Space replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Show Tabs toggle")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.tabReplacement))
                            ) {
                                Text(String(localized: "invisibles.tab-replacement-label", defaultValue: "Character used to render tabs", comment: "Tab replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Show Line Endings toggle")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.lineFeedReplacement))
                            ) {
                                Text(String(localized: "invisibles.line-feed-replacement-label", defaultValue: "Character used to render line feeds (\\n)", comment: "Line feed replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.carriageReturnReplacement))
                            ) {
                                Text(String(localized: "invisibles.carriage-return-replacement-label", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Carriage return replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.paragraphSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.paragraph-separator-replacement-label", defaultValue: "Character used to render paragraph separators", comment: "Paragraph separator replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "invisibles.default-character", defaultValue: "Default: %@", comment: "Default character prompt"), Config.default.lineSeparatorReplacement))
                            ) {
                                Text(String(localized: "invisibles.line-separator-replacement-label", defaultValue: "Character used to render line separators", comment: "Line separator replacement label"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.section-title", defaultValue: "Invisible Characters", comment: "Invisible Characters section title"))
                    Text(String(localized: "invisibles.section-description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Invisible Characters section description"))
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
                    Text(String(localized: "alert.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
