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
                        TextField(String(localized: "settings.theme.details.name", defaultValue: "Name", comment: "Label for theme name in theme details"), text: $theme.displayName)
                        TextField(String(localized: "settings.theme.details.author", defaultValue: "Author", comment: "Label for theme author in theme details"), text: $theme.author)
                        Picker(String(localized: "settings.theme.details.type", defaultValue: "Type", comment: "Label for theme type in theme details"), selection: $theme.appearance) {
                            Text(String(localized: "settings.theme.details.type.light", defaultValue: "Light", comment: "Value indicating light theme type"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "settings.theme.details.type.dark", defaultValue: "Dark", comment: "Value indicating dark theme type"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "settings.theme.details.preview.text.primary", defaultValue: "Text", comment: "Preview sample text label in theme details primary text row")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.text.secondary", defaultValue: "Text", comment: "Preview sample text label in theme details secondary text row"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.cursor", defaultValue: "Cursor", comment: "Preview sample label for cursor color in theme details"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.invisibles", defaultValue: "Invisibles", comment: "Preview sample label for invisible characters in theme details"),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.preview.background", defaultValue: "Background", comment: "Preview sample label for background color in theme details")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.background.secondary", defaultValue: "Background", comment: "Secondary background preview label in theme details"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.current-line", defaultValue: "Current Line", comment: "Preview label for current line highlight in theme details"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.preview.selection", defaultValue: "Selection", comment: "Preview label for selection color in theme details"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.tokens", defaultValue: "Tokens", comment: "Section header for token colors in theme details")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.keywords", defaultValue: "Keywords", comment: "Token color label for keywords in theme details"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.commands", defaultValue: "Commands", comment: "Token color label for commands in theme details"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.types", defaultValue: "Types", comment: "Token color label for types in theme details"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.attributes", defaultValue: "Attributes", comment: "Token color label for attributes in theme details"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.variables", defaultValue: "Variables", comment: "Token color label for variables in theme details"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.values", defaultValue: "Values", comment: "Token color label for values in theme details"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.numbers", defaultValue: "Numbers", comment: "Token color label for numbers in theme details"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.strings", defaultValue: "Strings", comment: "Token color label for strings in theme details"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.characters", defaultValue: "Characters", comment: "Token color label for characters in theme details"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.comments", defaultValue: "Comments", comment: "Token color label for comments in theme details"),
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
                        Text(String(localized: "settings.theme.details.notice.duplicate-to-edit", defaultValue: "Duplicate this theme to make changes.", comment: "Instruction shown when a theme must be duplicated before editing"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "settings.theme.details.notice.bundled-theme-duplicate-required", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Explanation that bundled themes cannot be edited directly"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "settings.theme.details.notice.warning-duplicate-to-edit", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Warning message indicating duplication is required before editing"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "settings.theme.details.actions.delete-ellipsis", defaultValue: "Delete...", comment: "Button title to delete the current theme"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "settings.theme.details.actions.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Button title to duplicate the current theme"))
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
                        Text(String(localized: "settings.theme.details.confirmation.duplicate", defaultValue: "Duplicate", comment: "Confirmation button title for duplicating a theme"))
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
                        Text(String(localized: "settings.theme.details.actions.cancel", defaultValue: "Cancel", comment: "Cancel button title in theme details actions"))
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
                    Text(String(localized: "settings.theme.details.actions.done", defaultValue: "Done", comment: "Done button title in theme details"))
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
            Button(String(localized: "settings.theme.details.delete.confirmation.title", defaultValue: "Delete Theme", comment: "Alert title for deleting a theme")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "settings.theme.details.delete.confirmation.cancel", defaultValue: "Cancel", comment: "Cancel button title in delete theme confirmation alert")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.details.delete.confirmation.warning", defaultValue: "This action cannot be undone.", comment: "Warning text in delete theme confirmation alert"))
        }
    }
}
