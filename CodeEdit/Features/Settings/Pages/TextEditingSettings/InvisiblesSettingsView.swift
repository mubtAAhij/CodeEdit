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
                        Toggle(isOn: $invisibleCharacters.showSpaces) { Text(String(
                            localized: "settings.text-editing.invisibles.show-spaces",
                            defaultValue: "Show Spaces",
                            comment: "Toggle label for displaying space characters as invisibles."
                        )) }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-space-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for spaces."
                                ), "\(Config.default.spaceReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.space-replacement.help",
                                    defaultValue: "Character used to render spaces",
                                    comment: "Help text for the space replacement character field."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { Text(String(
                            localized: "settings.text-editing.invisibles.show-tabs",
                            defaultValue: "Show Tabs",
                            comment: "Toggle label for displaying tab characters as invisibles."
                        )) }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-tab-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for tabs."
                                ), "\(Config.default.tabReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.tab-replacement.help",
                                    defaultValue: "Character used to render tabs",
                                    comment: "Help text for the tab replacement character field."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { Text(String(
                            localized: "settings.text-editing.invisibles.show-line-endings",
                            defaultValue: "Show Line Endings",
                            comment: "Toggle label for displaying line ending characters as invisibles."
                        )) }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-line-feed-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for line feeds."
                                ), "\(Config.default.lineFeedReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.line-feed-replacement.help",
                                    defaultValue: "Character used to render line feeds (\\n)",
                                    comment: "Help text for line feed replacement character setting."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-carriage-return-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for carriage returns."
                                ), "\(Config.default.carriageReturnReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.carriage-return-replacement.help",
                                    defaultValue: "Character used to render carriage returns (Microsoft-style line endings)",
                                    comment: "Help text for the carriage return replacement character field."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-paragraph-separator-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for paragraph separators."
                                ), "\(Config.default.paragraphSeparatorReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.paragraph-separator-replacement.help",
                                    defaultValue: "Character used to render paragraph separators",
                                    comment: "Help text for the paragraph separator replacement character field."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(format: String(
                                    localized: "settings.text-editing.invisibles.default-line-separator-replacement",
                                    defaultValue: "Default: %@",
                                    comment: "Label showing the default replacement character for line separators."
                                ), "\(Config.default.lineSeparatorReplacement)"))
                            ) {
                                Text(String(
                                    localized: "settings.text-editing.invisibles.line-separator-replacement.help",
                                    defaultValue: "Character used to render line separators",
                                    comment: "Help text for the line separator replacement character field."
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(
                        localized: "settings.text-editing.invisibles.title",
                        defaultValue: "Invisible Characters",
                        comment: "Section title for invisible character rendering settings."
                    ))
                    Text(String(
                        localized: "settings.text-editing.invisibles.description",
                        defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.",
                        comment: "Description for invisible character rendering settings."
                    ))
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
                    Text(String(
                        localized: "settings.text-editing.invisibles.done",
                        defaultValue: "Done",
                        comment: "Button title to close the invisibles settings sheet."
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
