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
                            Text(String(localized: "invisibles.showSpaces", comment: "Toggle label")) 
                        }
                        if invisibleCharacters.showSpaces {
                            TextField(
                                text: $invisibleCharacters.spaceReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.spaceDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.spaceReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.spaceCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showTabs) { 
                            Text(String(localized: "invisibles.showTabs", comment: "Toggle label")) 
                        }
                        if invisibleCharacters.showTabs {
                            TextField(
                                text: $invisibleCharacters.tabReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.tabDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.tabReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.tabCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }

                    VStack {
                        Toggle(isOn: $invisibleCharacters.showLineEndings) { 
                            Text(String(localized: "invisibles.showLineEndings", comment: "Toggle label")) 
                        }
                        if invisibleCharacters.showLineEndings {
                            TextField(
                                text: $invisibleCharacters.lineFeedReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.lineFeedDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.lineFeedReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.lineFeedCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.carriageReturnReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.carriageReturnDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.carriageReturnReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.carriageReturnCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.paragraphSeparatorReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.paragraphSeparatorDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.paragraphSeparatorReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.paragraphSeparatorCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()

                            TextField(
                                text: $invisibleCharacters.lineSeparatorReplacement,
                                prompt: Text(String(
                                    localized: "invisibles.lineSeparatorDefault", 
                                    comment: "Placeholder text", 
                                    arguments: Config.default.lineSeparatorReplacement
                                ))
                            ) {
                                Text(String(localized: "invisibles.lineSeparatorCharacter", comment: "Label text"))
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .autocorrectionDisabled()
                        }
                    }
                } header: {
                    Text(String(localized: "invisibles.title", comment: "Section title"))
                    Text(String(localized: "invisibles.description", comment: "Description text"))
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
                    Text(String(localized: "invisibles.done", comment: "Button text"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
