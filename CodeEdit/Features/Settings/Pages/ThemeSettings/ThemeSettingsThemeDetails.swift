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
                        TextField(String(localized: "settings.theme.name", defaultValue: "Name", comment: "Label for theme name field"), text: $theme.displayName)
                        TextField(String(localized: "settings.theme.author", defaultValue: "Author", comment: "Label for theme author field"), text: $theme.author)
                        Picker(String(localized: "settings.theme.type", defaultValue: "Type", comment: "Label for theme type picker"), selection: $theme.appearance) {
                            Text(String(localized: "settings.theme.type.light", defaultValue: "Light", comment: "Light theme type option"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "settings.theme.type.dark", defaultValue: "Dark", comment: "Dark theme type option"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section("Text") {
                        SettingsColorPicker(
                            "Text",
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.cursor", defaultValue: "Cursor", comment: "Label for cursor color"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.background", defaultValue: "Background", comment: "Section header for background colors")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.background", defaultValue: "Background", comment: "Label for background color"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.current-line", defaultValue: "Current Line", comment: "Label for current line color"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.selection", defaultValue: "Selection", comment: "Label for selection color"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.tokens", defaultValue: "Tokens", comment: "Section header for token colors")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.keywords", defaultValue: "Keywords", comment: "Label for keywords token color"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.commands", defaultValue: "Commands", comment: "Label for commands token color"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.types", defaultValue: "Types", comment: "Label for types token color"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.attributes", defaultValue: "Attributes", comment: "Label for attributes token color"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.variables", defaultValue: "Variables", comment: "Label for variables token color"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.values", defaultValue: "Values", comment: "Label for values token color"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.numbers", defaultValue: "Numbers", comment: "Label for numbers token color"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.strings", defaultValue: "Strings", comment: "Label for strings token color"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.characters", defaultValue: "Characters", comment: "Label for characters token color"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.tokens.comments", defaultValue: "Comments", comment: "Label for comments token color"),
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
                        Text(String(localized: "settings.theme.duplicate-to-edit", defaultValue: "Duplicate this theme to make changes.", comment: "Message prompting user to duplicate theme to make changes"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "settings.theme.bundled-theme-help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Help text explaining bundled themes cannot be edited"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "settings.theme.bundled-theme-warning", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Accessibility label warning about bundled theme"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "settings.theme.delete-ellipsis", defaultValue: "Delete...", comment: "Button to delete theme with ellipsis"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "settings.theme.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Button to duplicate theme with ellipsis"))
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
                        Text(String(localized: "settings.theme.duplicate", defaultValue: "Duplicate", comment: "Button to duplicate theme"))
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
                        Text(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button"))
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
                    Text(String(localized: "done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: NSLocalizedString("settings.theme.delete-confirmation.title", comment: "Alert title for deleting theme"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "settings.theme.delete-theme", defaultValue: "Delete Theme", comment: "Button to confirm theme deletion")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.delete-confirmation.message", defaultValue: "This action cannot be undone.", comment: "Message warning about irreversible theme deletion"))
        }
    }
}
