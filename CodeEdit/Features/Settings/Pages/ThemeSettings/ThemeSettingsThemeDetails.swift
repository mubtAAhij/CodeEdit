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
                        TextField(String(localized: "theme-settings.name", defaultValue: "Name", comment: "Name field label"), text: $theme.displayName)
                        TextField(String(localized: "theme-settings.author", defaultValue: "Author", comment: "Author field label"), text: $theme.author)
                        Picker(String(localized: "theme-settings.type", defaultValue: "Type", comment: "Type picker label"), selection: $theme.appearance) {
                            Text(String(localized: "theme-settings.light", defaultValue: "Light", comment: "Light theme type option"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme-settings.dark", defaultValue: "Dark", comment: "Dark theme type option"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme-settings.text-section", defaultValue: "Text", comment: "Text section title")) {
                        SettingsColorPicker(
                            String(localized: "theme-settings.text-color", defaultValue: "Text", comment: "Text color label"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-settings.cursor", defaultValue: "Cursor", comment: "Cursor color label"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme-settings.background-section", defaultValue: "Background", comment: "Background section title")) {
                        SettingsColorPicker(
                            String(localized: "theme-settings.background-color", defaultValue: "Background", comment: "Background color label"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-settings.current-line", defaultValue: "Current Line", comment: "Current line color label"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-settings.selection", defaultValue: "Selection", comment: "Selection color label"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme-settings.tokens-section", defaultValue: "Tokens", comment: "Tokens section title")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.keywords", defaultValue: "Keywords", comment: "Keywords token label"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.commands", defaultValue: "Commands", comment: "Commands token label"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.types", defaultValue: "Types", comment: "Types token label"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.attributes", defaultValue: "Attributes", comment: "Attributes token label"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.variables", defaultValue: "Variables", comment: "Variables token label"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.values", defaultValue: "Values", comment: "Values token label"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.numbers", defaultValue: "Numbers", comment: "Numbers token label"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.strings", defaultValue: "Strings", comment: "Strings token label"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.characters", defaultValue: "Characters", comment: "Characters token label"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-settings.comments", defaultValue: "Comments", comment: "Comments token label"),
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
                        Text(String(localized: "theme-settings.duplicate-to-edit-message", defaultValue: "Duplicate this theme to make changes.", comment: "Duplicate theme to edit message"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme-settings.bundled-themes-help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Bundled themes help text"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme-settings.duplicate-to-edit-warning", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Duplicate theme warning accessibility label"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme-settings.delete-button", defaultValue: "Delete...", comment: "Delete theme button"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme-settings.duplicate-button-ellipsis", defaultValue: "Duplicate...", comment: "Duplicate theme button with ellipsis"))
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
                        Text(String(localized: "theme-settings.duplicate-button", defaultValue: "Duplicate", comment: "Duplicate theme button"))
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
                        Text(String(localized: "theme-settings.cancel-button", defaultValue: "Cancel", comment: "Cancel button"))
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
                    Text(String(localized: "theme-settings.done-button", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "theme-settings.delete-confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Delete theme confirmation message"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-settings.delete-theme-button", defaultValue: "Delete Theme", comment: "Delete theme confirmation button")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme-settings.cancel-delete-button", defaultValue: "Cancel", comment: "Cancel delete button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-settings.cannot-undo-message", defaultValue: "This action cannot be undone.", comment: "Cannot undo action message"))
        }
    }
}
