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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "settings.text-editing.invisibles.show-spaces.title", defaultValue: "Show Spaces", comment: "Toggle title for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.spaces.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for spaces"), "\(Config.default.spaceReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.spaces.description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "settings.text-editing.invisibles.show-tabs.title", defaultValue: "Show Tabs", comment: "Toggle title for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.tabs.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for tabs"), "\(Config.default.tabReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.tabs.description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "settings.text-editing.invisibles.show-line-endings.title", defaultValue: "Show Line Endings", comment: "Toggle title for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.line-feed.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for line feeds"), "\(Config.default.lineFeedReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-feed.description", defaultValue: "Character used to render line feeds (\\n)", comment: "Description for line feed replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.carriage-return.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for carriage returns"), "\(Config.default.carriageReturnReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.carriage-return.description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.paragraph-separator.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for paragraph separators"), "\(Config.default.paragraphSeparatorReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.paragraph-separator.description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(localized: "settings.text-editing.invisibles.line-separator.default-value", defaultValue: "Default: %@", comment: "Default replacement character shown for line separators"), "\(Config.default.lineSeparatorReplacement)"))
                            ) {
                                Text(String(localized: "settings.text-editing.invisibles.line-separator.description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "settings.text-editing.invisibles.title", defaultValue: "Invisible Characters", comment: "Title for invisible characters settings sheet"))
                    Text(String(localized: "settings.text-editing.invisibles.subtitle", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Subtitle explaining invisible character rendering settings"))
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
                    Text(String(localized: "settings.text-editing.invisibles.done.button", defaultValue: "Done", comment: "Button title to close invisible characters settings"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
