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
                        TextField(String(localized: "theme-details.name", defaultValue: "Name", comment: "Label for theme name field"), text: $theme.displayName)
                        TextField(String(localized: "theme-details.author", defaultValue: "Author", comment: "Label for theme author field"), text: $theme.author)
                        Picker(String(localized: "theme-details.type", defaultValue: "Type", comment: "Label for theme type picker"), selection: $theme.appearance) {
                            Text(String(localized: "theme-details.type.light", defaultValue: "Light", comment: "Light theme type option"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme-details.type.dark", defaultValue: "Dark", comment: "Dark theme type option"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme-details.section.text", defaultValue: "Text", comment: "Section header for text colors")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.text", defaultValue: "Text", comment: "Label for text color picker"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.cursor", defaultValue: "Cursor", comment: "Label for cursor color picker"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.invisibles", defaultValue: "Invisibles", comment: "Label for invisibles color picker"),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.background", defaultValue: "Background", comment: "Section header for background colors")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.background", defaultValue: "Background", comment: "Label for background color picker"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.current-line", defaultValue: "Current Line", comment: "Label for current line color picker"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.selection", defaultValue: "Selection", comment: "Label for selection color picker"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.tokens", defaultValue: "Tokens", comment: "Section header for syntax token colors")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.keywords", defaultValue: "Keywords", comment: "Label for keywords token"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.commands", defaultValue: "Commands", comment: "Label for commands token"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.types", defaultValue: "Types", comment: "Label for types token"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.attributes", defaultValue: "Attributes", comment: "Label for attributes token"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.variables", defaultValue: "Variables", comment: "Label for variables token"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.values", defaultValue: "Values", comment: "Label for values token"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.numbers", defaultValue: "Numbers", comment: "Label for numbers token"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.strings", defaultValue: "Strings", comment: "Label for strings token"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.characters", defaultValue: "Characters", comment: "Label for characters token"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.comments", defaultValue: "Comments", comment: "Label for comments token"),
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
                        Text(String(localized: "theme-details.bundled-warning", defaultValue: "Duplicate this theme to make changes.", comment: "Warning message for bundled themes"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme-details.bundled-warning.help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Help text for bundled theme warning"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme-details.bundled-warning.accessibility", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Accessibility label for bundled theme warning"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme-details.delete-button", defaultValue: "Delete...", comment: "Button to delete theme"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme-details.duplicate-button", defaultValue: "Duplicate...", comment: "Button to duplicate theme"))
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
                        Text(String(localized: "theme-details.duplicate", defaultValue: "Duplicate", comment: "Button to duplicate bundled theme"))
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
                        Text(String(localized: "theme-details.cancel", defaultValue: "Cancel", comment: "Button to cancel theme editing"))
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
                    Text(String(localized: "theme-details.done", defaultValue: "Done", comment: "Button to finish theme editing"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "theme-details.delete.confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Confirmation message before deleting a theme"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-details.delete.action", defaultValue: "Delete Theme", comment: "Button to confirm theme deletion")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme-details.delete.cancel", defaultValue: "Cancel", comment: "Button to cancel theme deletion")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-details.delete.warning", defaultValue: "This action cannot be undone.", comment: "Warning message for theme deletion"))
        }
    }
}
