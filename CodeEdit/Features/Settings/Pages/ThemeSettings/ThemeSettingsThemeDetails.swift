//
//  ThemeSettingsThemeDetails.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/3/23.
//

import SwiftUI

struct ThemeSettingsThemeDetails: View {
    @Environment(\.dismiss)
    var dismiss

    @Environment(\.colorScheme)
    var colorScheme

    @Binding var theme: Theme

    var originalTheme: Theme

    @StateObject private var themeModel: ThemeModel = .shared

    @State private var duplicatingTheme: Theme?

    @State private var deleteConfirmationIsPresented = false

    var isActive: Bool {
        themeModel.getThemeActive(theme)
    }

    init(theme: Binding<Theme>) {
        _theme = theme
        originalTheme = theme.wrappedValue
    }

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Group {
                    Section {
                        TextField(String(
                            localized: "settings.theme-details.name.label",
                            defaultValue: "Name",
                            comment: "Label for theme name field"
                        ), text: $theme.displayName)
                        TextField(String(
                            localized: "settings.theme-details.author.label",
                            defaultValue: "Author",
                            comment: "Label for theme author field"
                        ), text: $theme.author)
                        Picker(String(
                            localized: "settings.theme-details.type.label",
                            defaultValue: "Type",
                            comment: "Label for theme type field"
                        ), selection: $theme.appearance) {
                            Text(String(
                                localized: "settings.theme-details.type.light.value",
                                defaultValue: "Light",
                                comment: "Value label for light theme type"
                            ))
                                .tag(Theme.ThemeType.light)
                            Text(String(
                                localized: "settings.theme-details.type.dark.value",
                                defaultValue: "Dark",
                                comment: "Value label for dark theme type"
                            ))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(
                        localized: "settings.theme-details.editor.text.section",
                        defaultValue: "Text",
                        comment: "Section title for text color settings"
                    )) {
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.text.color.label",
                                defaultValue: "Text",
                                comment: "Label for text color value"
                            ),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.cursor.color.label",
                                defaultValue: "Cursor",
                                comment: "Label for cursor color value"
                            ),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.invisibles.color.label",
                                defaultValue: "Invisibles",
                                comment: "Label for invisibles color value"
                            ),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(
                        localized: "settings.theme-details.editor.background.section",
                        defaultValue: "Background",
                        comment: "Section title for background color settings"
                    )) {
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.background.color.label",
                                defaultValue: "Background",
                                comment: "Label for background color value"
                            ),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.current-line.color.label",
                                defaultValue: "Current Line",
                                comment: "Label for current line highlight color"
                            ),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme-details.editor.selection.color.label",
                                defaultValue: "Selection",
                                comment: "Label for selection color value"
                            ),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(
                        localized: "settings.theme-details.tokens.section",
                        defaultValue: "Tokens",
                        comment: "Section title for token color settings"
                    )) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.keywords.label",
                                    defaultValue: "Keywords",
                                    comment: "Label for keyword token color"
                                ),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.commands.label",
                                    defaultValue: "Commands",
                                    comment: "Label for command token color"
                                ),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.types.label",
                                    defaultValue: "Types",
                                    comment: "Label for type token color"
                                ),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.attributes.label",
                                    defaultValue: "Attributes",
                                    comment: "Label for attribute token color"
                                ),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.variables.label",
                                    defaultValue: "Variables",
                                    comment: "Label for variable token color"
                                ),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.values.label",
                                    defaultValue: "Values",
                                    comment: "Label for value token color"
                                ),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.numbers.label",
                                    defaultValue: "Numbers",
                                    comment: "Label for number token color setting"
                                ),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.strings.label",
                                    defaultValue: "Strings",
                                    comment: "Label for string token color setting"
                                ),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.characters.label",
                                    defaultValue: "Characters",
                                    comment: "Label for character token color setting"
                                ),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme-details.tokens.comments.label",
                                    defaultValue: "Comments",
                                    comment: "Label for comment token color setting"
                                ),
                                color: $theme.editor.comments.swiftColor,
                                bold: $theme.editor.comments.bold,
                                italic: $theme.editor.comments.italic
                            )
                        }
                        .background(theme.editor.background.swiftColor)
                        .padding(-10)
                        .colorScheme(
                            theme.appearance == .dark
                            ? .dark
                            : theme.appearance == .light
                            ? .light : colorScheme
                        )
                    }
                }
                .disabled(theme.isBundled)
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                if theme.isBundled {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.body)
                            .foregroundStyle(Color.yellow)
                        Text(String(
                            localized: "settings.theme-details.duplicate-theme-to-edit.message",
                            defaultValue: "Duplicate this theme to make changes.",
                            comment: "Message explaining that duplicating is required before editing theme"
                        ))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(
                        localized: "settings.theme-details.bundled-theme-duplicate-required.message",
                        defaultValue: "Bundled themes must be duplicated to make changes.",
                        comment: "Message explaining bundled themes must be duplicated before editing"
                    ))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(
                        localized: "settings.theme-details.duplicate-theme-warning.message",
                        defaultValue: "Warning: Duplicate this theme to make changes.",
                        comment: "Warning message about duplicating theme before edits"
                    ))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(
                            localized: "settings.theme-details.delete.button",
                            defaultValue: "Delete...",
                            comment: "Button title for deleting current theme"
                        ))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(
                            localized: "settings.theme-details.duplicate.button",
                            defaultValue: "Duplicate...",
                            comment: "Button title for duplicating current theme"
                        ))
                            .frame(minWidth: 56)
                    }
                }
                Spacer()
                if !themeModel.isAdding && theme.isBundled {
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(
                            localized: "settings.theme-details.duplicate.confirm.button",
                            defaultValue: "Duplicate",
                            comment: "Confirmation button title for duplicating theme"
                        ))
                            .frame(minWidth: 56)
                    }
                } else {
                    Button {
                        if themeModel.isAdding {
                            if let previousTheme = themeModel.previousTheme {
                                themeModel.activateTheme(previousTheme)
                            }
                            if let duplicatingWithinDetails = duplicatingTheme {
                                let duplicateTheme = theme
                                themeModel.detailsTheme = duplicatingWithinDetails
                                themeModel.delete(duplicateTheme)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    themeModel.delete(theme)
                                }
                            }
                        } else {
                            themeModel.cancelDetails(theme)
                        }

                        if duplicatingTheme == nil {
                            dismiss()
                        } else {
                            duplicatingTheme = nil
                            themeModel.isAdding = false
                        }
                    } label: {
                        Text(String(
                            localized: "settings.theme-details.duplicate.cancel.button",
                            defaultValue: "Cancel",
                            comment: "Cancel button title in duplicate theme dialog"
                        ))
                            .frame(minWidth: 56)
                    }
                    .buttonStyle(.bordered)
                }
                Button {
                    if !theme.isBundled {
                        themeModel.rename(to: theme.displayName, theme: theme)
                    }
                    dismiss()
                } label: {
                    Text(String(
                        localized: "settings.theme-details.done.button",
                        defaultValue: "Done",
                        comment: "Done button title to close theme details view"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(
                localized: "settings.theme-details.delete-theme.confirmation.title",
                defaultValue: "Are you sure you want to delete the theme “%@”?",
                comment: "Confirmation title asking to delete selected theme"
            ), "\(theme.displayName)")),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(
                localized: "settings.theme-details.delete-theme.confirm.button",
                defaultValue: "Delete Theme",
                comment: "Destructive confirmation button title for deleting theme"
            )) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(
                localized: "settings.theme-details.delete-theme.cancel.button",
                defaultValue: "Cancel",
                comment: "Cancel button title in delete theme confirmation alert"
            )) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(
                localized: "settings.theme-details.delete-theme.warning.message",
                defaultValue: "This action cannot be undone.",
                comment: "Warning message shown in delete theme confirmation"
            ))
        }
    }
}
