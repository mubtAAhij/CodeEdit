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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(localized: "invisibles.settings.show_spaces", comment: "Toggle for showing space characters")) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(localized: "invisibles.settings.default_replacement", arguments: [Config.default.spaceReplacement], comment: "Default replacement character placeholder"))
                            ) {
                                Text(String(localized: "invisibles.settings.space_character.help", comment: "Help text for space replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(localized: "invisibles.settings.show_tabs", comment: "Toggle for showing tab characters")) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(localized: "invisibles.settings.default_replacement", arguments: [Config.default.tabReplacement], comment: "Default replacement character placeholder"))
                            ) {
                                Text(String(localized: "invisibles.settings.tab_character.help", comment: "Help text for tab replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(localized: "invisibles.settings.show_line_endings", comment: "Toggle for showing line ending characters")) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(localized: "invisibles.settings.default_replacement", arguments: [Config.default.lineFeedReplacement], comment: "Default replacement character placeholder"))
                            ) {
                                Text(String(localized: "invisibles.settings.line_feed_character.help", comment: "Help text for line feed replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(localized: "invisibles.settings.default_replacement", arguments: [Config.default.carriageReturnReplacement], comment: "Default replacement character placeholder"))
                            ) {
                                Text(String(localized: "invisibles.settings.carriage_return_character.help", comment: "Help text for carriage return replacement character"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(localized: "invisibles.settings.default_replacement", arguments: [Config.default.paragraphSeparatorReplacement], comment: "Default replacement character placeholder"))
                            ) {
                                Text("Character used to render paragraph separators")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text("Default: \(Config.default.lineSeparatorReplacement)")
                            ) {
                                Text("Character used to render line separators")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text("Invisible Characters")
                    Text("Toggle whitespace symbols CodeEdit will render with replacement characters.")
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
                    Text("Done")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
