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
                        TextField(String(localized: "settings.theme.theme-details.name", defaultValue: "Name", comment: "Label for theme name in theme details."), text: $theme.displayName)
                        TextField(String(localized: "settings.theme.theme-details.author", defaultValue: "Author", comment: "Label for theme author in theme details."), text: $theme.author)
                        Picker(String(localized: "settings.theme.theme-details.type", defaultValue: "Type", comment: "Label for theme type in theme details."), selection: $theme.appearance) {
                            Text(String(localized: "settings.theme.theme-details.type.light", defaultValue: "Light", comment: "Theme type value indicating light theme."))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "settings.theme.theme-details.type.dark", defaultValue: "Dark", comment: "Theme type value indicating dark theme."))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "settings.theme.theme-details.color.text.primary", defaultValue: "Text", comment: "Label for primary text color in theme details.")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.color.text.secondary", defaultValue: "Text", comment: "Label for secondary text color in theme details."),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.color.cursor", defaultValue: "Cursor", comment: "Label for cursor color in theme details."),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.color.invisibles", defaultValue: "Invisibles", comment: "Label for invisibles color in theme details."),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.theme-details.color.background", defaultValue: "Background", comment: "Label for background color in theme details.")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.tokens.background.secondary", defaultValue: "Background", comment: "Secondary background color label in theme details."),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.current-line", defaultValue: "Current Line", comment: "Label for current line color in theme details."),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.theme-details.selection", defaultValue: "Selection", comment: "Label for selection color in theme details."),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.theme-details.tokens.section", defaultValue: "Tokens", comment: "Section header for token colors in theme details.")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.keywords", defaultValue: "Keywords", comment: "Label for keyword token color in theme details."),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.commands", defaultValue: "Commands", comment: "Label for command token color in theme details."),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.types", defaultValue: "Types", comment: "Label for type token color in theme details."),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.attributes", defaultValue: "Attributes", comment: "Label for attribute token color in theme details."),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.variables", defaultValue: "Variables", comment: "Label for variable token color in theme details."),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.values", defaultValue: "Values", comment: "Label for value token color in theme details."),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.numbers", defaultValue: "Numbers", comment: "Label for number token color in theme details."),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.strings", defaultValue: "Strings", comment: "Label for string token color in theme details."),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.characters", defaultValue: "Characters", comment: "Label for character token color in theme details."),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.theme-details.tokens.comments", defaultValue: "Comments", comment: "Label for comment token color in theme details."),
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
                        Text(String(localized: "settings.theme.theme-details.warning.duplicate-to-edit", defaultValue: "Duplicate this theme to make changes.", comment: "Message prompting user to duplicate theme before editing."))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "settings.theme.theme-details.warning.bundled-theme-readonly", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Warning that bundled themes are read-only and must be duplicated before editing."))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "settings.theme.theme-details.warning.title-and-message", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Warning label shown for non-editable theme details."))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "settings.theme.theme-details.actions.delete", defaultValue: "Delete...", comment: "Button title for deleting the selected theme."))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "settings.theme.theme-details.actions.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Button title for duplicating the selected theme."))
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
                        Text(String(localized: "settings.theme.theme-details.actions.duplicate", defaultValue: "Duplicate", comment: "Confirmation action title for duplicating a theme."))
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
                        Text(String(localized: "settings.theme.theme-details.duplicate-dialog.cancel", defaultValue: "Cancel", comment: "Cancel button title in duplicate theme dialog."))
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
                    Text(String(localized: "settings.theme.theme-details.duplicate-dialog.done", defaultValue: "Done", comment: "Done button title in duplicate theme dialog."))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text("Are you sure you want to delete the theme “\(theme.displayName)”?"),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "settings.theme.theme-details.delete-confirmation.title", defaultValue: "Delete Theme", comment: "Title for delete theme confirmation alert.")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "settings.theme.theme-details.delete-confirmation.cancel", defaultValue: "Cancel", comment: "Cancel button title in delete theme confirmation alert.")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.theme-details.delete-confirmation.warning", defaultValue: "This action cannot be undone.", comment: "Warning text in delete theme confirmation alert."))
        }
    }
}
