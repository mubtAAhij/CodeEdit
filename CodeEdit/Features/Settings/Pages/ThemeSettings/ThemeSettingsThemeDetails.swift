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
                        TextField(String(localized: "theme-details.name", defaultValue: "Name", comment: "Theme name field label"), text: $theme.displayName)
                        TextField(String(localized: "theme-details.author", defaultValue: "Author", comment: "Theme author field label"), text: $theme.author)
                        Picker(String(localized: "theme-details.type", defaultValue: "Type", comment: "Theme type picker label"), selection: $theme.appearance) {
                            Text(String(localized: "theme-details.type.light", defaultValue: "Light", comment: "Light theme type option"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme-details.type.dark", defaultValue: "Dark", comment: "Dark theme type option"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme-details.section.text", defaultValue: "Text", comment: "Text section header in theme details")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.text.label", defaultValue: "Text", comment: "Text color picker label"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.cursor", defaultValue: "Cursor", comment: "Cursor color picker label"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.invisibles", defaultValue: "Invisibles", comment: "Invisibles color picker label"),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.background", defaultValue: "Background", comment: "Background section header in theme details")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.background.label", defaultValue: "Background", comment: "Background color picker label"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.current-line", defaultValue: "Current Line", comment: "Current line color picker label"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.selection", defaultValue: "Selection", comment: "Selection color picker label"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.tokens", defaultValue: "Tokens", comment: "Tokens section header in theme details")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.keywords", defaultValue: "Keywords", comment: "Keywords token label"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.commands", defaultValue: "Commands", comment: "Commands token label"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.types", defaultValue: "Types", comment: "Types token label"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.attributes", defaultValue: "Attributes", comment: "Attributes token label"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.variables", defaultValue: "Variables", comment: "Variables token label"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.values", defaultValue: "Values", comment: "Values token label"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.numbers", defaultValue: "Numbers", comment: "Numbers token label"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.strings", defaultValue: "Strings", comment: "Strings token label"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.characters", defaultValue: "Characters", comment: "Characters token label"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.token.comments", defaultValue: "Comments", comment: "Comments token label"),
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
                        Text(String(localized: "theme-details.bundled.warning", defaultValue: "Duplicate this theme to make changes.", comment: "Warning message for bundled themes"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme-details.bundled.help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Help text for bundled theme warning"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme-details.bundled.accessibility", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Accessibility label for bundled theme warning"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme-details.delete", defaultValue: "Delete...", comment: "Delete theme button"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme-details.duplicate", defaultValue: "Duplicate...", comment: "Duplicate theme button"))
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
                        Text(String(localized: "theme-details.duplicate.action", defaultValue: "Duplicate", comment: "Duplicate theme action button"))
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
                        Text(String(localized: "theme-details.cancel", defaultValue: "Cancel", comment: "Cancel button"))
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
                    Text(String(localized: "theme-details.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "theme-details.delete.confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Delete theme confirmation message"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-details.delete.action", defaultValue: "Delete Theme", comment: "Delete theme confirmation button")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme-details.delete.cancel", defaultValue: "Cancel", comment: "Cancel delete button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-details.delete.warning", defaultValue: "This action cannot be undone.", comment: "Delete warning message"))
        }
    }
}
