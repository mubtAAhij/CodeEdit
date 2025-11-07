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
                        Toggle(isOn: $invisibleCharacters.showSpaces) {
                            Text(String(
                                localized: "invisibles-settings.show-spaces",
                                defaultValue: "Show Spaces",
                                comment: "Toggle to show space characters"
                            ))
                        }
                        if invisibleCharacters.showSpaces {
                            let defaultReplacement = Config.default.spaceReplacement
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.spaces-default",
                                    defaultValue: "Default: \(defaultReplacement)",
                                    comment: "Placeholder showing default space replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.spaces-description",
                                    defaultValue: "Character used to render spaces",
                                    comment: "Description of space replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) {
                            Text(String(
                                localized: "invisibles-settings.show-tabs",
                                defaultValue: "Show Tabs",
                                comment: "Toggle to show tab characters"
                            ))
                        }
                        if invisibleCharacters.showTabs {
                            let defaultReplacement = Config.default.tabReplacement
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.tabs-default",
                                    defaultValue: "Default: \(defaultReplacement)",
                                    comment: "Placeholder showing default tab replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.tabs-description",
                                    defaultValue: "Character used to render tabs",
                                    comment: "Description of tab replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) {
                            Text(String(
                                localized: "invisibles-settings.show-line-endings",
                                defaultValue: "Show Line Endings",
                                comment: "Toggle to show line ending characters"
                            ))
                        }
                        if invisibleCharacters.showLineEndings {
                            let lineFeedDefault = Config.default.lineFeedReplacement
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.line-feed-default",
                                    defaultValue: "Default: \(lineFeedDefault)",
                                    comment: "Placeholder showing default line feed replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.line-feed-description",
                                    defaultValue: "Character used to render line feeds (\\n)",
                                    comment: "Description of line feed replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            let carriageReturnDefault = Config.default.carriageReturnReplacement
                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.carriage-return-default",
                                    defaultValue: "Default: \(carriageReturnDefault)",
                                    comment: "Placeholder showing default carriage return replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.carriage-return-description",
                                    defaultValue: "Character used to render carriage returns (Microsoft-style line endings)",
                                    comment: "Description of carriage return replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            let paragraphSeparatorDefault = Config.default.paragraphSeparatorReplacement
                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.paragraph-separator-default",
                                    defaultValue: "Default: \(paragraphSeparatorDefault)",
                                    comment: "Placeholder showing default paragraph separator replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.paragraph-separator-description",
                                    defaultValue: "Character used to render paragraph separators",
                                    comment: "Description of paragraph separator replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            let lineSeparatorDefault = Config.default.lineSeparatorReplacement
                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(
                                    localized: "invisibles-settings.line-separator-default",
                                    defaultValue: "Default: \(lineSeparatorDefault)",
                                    comment: "Placeholder showing default line separator replacement character"
                                ))
                            ) {
                                Text(String(
                                    localized: "invisibles-settings.line-separator-description",
                                    defaultValue: "Character used to render line separators",
                                    comment: "Description of line separator replacement character field"
                                ))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(
                        localized: "invisibles-settings.header",
                        defaultValue: "Invisible Characters",
                        comment: "Section header for invisible characters settings"
                    ))
                    Text(String(
                        localized: "invisibles-settings.header-description",
                        defaultValue: "Toggle whitespace symbols CodeEdit will render with replacement characters.",
                        comment: "Description of invisible characters settings section"
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
                        localized: "invisibles-settings.done",
                        defaultValue: "Done",
                        comment: "Button to close invisibles settings sheet"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
