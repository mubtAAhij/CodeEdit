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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "text-editing.invisibles.show-spaces", defaultValue: "Show Spaces", comment: "Toggle label for showing visible space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text("Default: \(Config.default.spaceReplacement)")
                            ) {
                                Text(String(localized: "text-editing.invisibles.space-replacement-description", defaultValue: "Character used to render spaces", comment: "Description for space replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "text-editing.invisibles.show-tabs", defaultValue: "Show Tabs", comment: "Toggle label for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text("Default: \(Config.default.tabReplacement)")
                            ) {
                                Text(String(localized: "text-editing.invisibles.tab-replacement-description", defaultValue: "Character used to render tabs", comment: "Description for tab replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "text-editing.invisibles.show-line-endings", defaultValue: "Show Line Endings", comment: "Toggle label for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text("Default: \(Config.default.lineFeedReplacement)")
                            ) {
                                Text("Character used to render line feeds (\\n)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text("Default: \(Config.default.carriageReturnReplacement)")
                            ) {
                                Text(String(localized: "text-editing.invisibles.carriage-return-replacement-description", defaultValue: "Character used to render carriage returns (Microsoft-style line endings)", comment: "Description for carriage return replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.paragraphSeparatorReplacement)")
                            ) {
                                Text(String(localized: "text-editing.invisibles.paragraph-separator-replacement-description", defaultValue: "Character used to render paragraph separators", comment: "Description for paragraph separator replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.lineSeparatorReplacement)")
                            ) {
                                Text(String(localized: "text-editing.invisibles.line-separator-replacement-description", defaultValue: "Character used to render line separators", comment: "Description for line separator replacement character setting"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "text-editing.invisibles.title", defaultValue: "Invisible Characters", comment: "Title of invisible characters settings panel"))
                    Text(String(localized: "text-editing.invisibles.description", defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.", comment: "Description text for invisible characters settings panel"))
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
                    Text(String(localized: "text-editing.invisibles.done", defaultValue: "Done", comment: "Button title to close invisible characters settings panel"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
