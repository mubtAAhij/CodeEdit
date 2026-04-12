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
                        TextField(String(localized: "theme.name", defaultValue: "Name", comment: "Name text field"), text: $theme.displayName)
                        TextField(String(localized: "theme.author", defaultValue: "Author", comment: "Author text field"), text: $theme.author)
                        Picker(String(localized: "theme.type", defaultValue: "Type", comment: "Type picker"), selection: $theme.appearance) {
                            Text(String(localized: "theme.light", defaultValue: "Light", comment: "Light theme type"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme.dark", defaultValue: "Dark", comment: "Dark theme type"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme.text", defaultValue: "Text", comment: "Text section header")) {
                        SettingsColorPicker(
                            String(localized: "theme.text", defaultValue: "Text", comment: "Text section header"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme.cursor", defaultValue: "Cursor", comment: "Cursor color picker"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme.background", defaultValue: "Background", comment: "Background section header")) {
                        SettingsColorPicker(
                            String(localized: "theme.background", defaultValue: "Background", comment: "Background section header"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme.current-line", defaultValue: "Current Line", comment: "Current Line color picker"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme.selection", defaultValue: "Selection", comment: "Selection color picker"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme.tokens", defaultValue: "Tokens", comment: "Tokens section header")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "theme.keywords", defaultValue: "Keywords", comment: "Keywords token"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.commands", defaultValue: "Commands", comment: "Commands token"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.types", defaultValue: "Types", comment: "Types token"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.attributes", defaultValue: "Attributes", comment: "Attributes token"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.variables", defaultValue: "Variables", comment: "Variables token"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.values", defaultValue: "Values", comment: "Values token"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.numbers", defaultValue: "Numbers", comment: "Numbers token"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.strings", defaultValue: "Strings", comment: "Strings token"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.characters", defaultValue: "Characters", comment: "Characters token"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme.comments", defaultValue: "Comments", comment: "Comments token"),
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
                        Text(String(localized: "theme.duplicate-to-edit", defaultValue: "Duplicate this theme to make changes.", comment: "Duplicate this theme to make changes message"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme.bundled-must-duplicate", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Bundled themes must be duplicated help text"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme.warning-duplicate-to-edit", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Warning duplicate this theme accessibility label"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme.delete", defaultValue: "Delete...", comment: "Delete button"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Duplicate button"))
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
                        Text(String(localized: "theme.duplicate", defaultValue: "Duplicate", comment: "Duplicate button"))
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
                        Text(String(localized: "theme.cancel", defaultValue: "Cancel", comment: "Cancel button"))
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
                    Text(String(localized: "theme.done", defaultValue: "Done", comment: "Done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "theme.delete-confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Delete theme confirmation message"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme.delete-theme", defaultValue: "Delete Theme", comment: "Delete Theme button")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme.cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme.cannot-undo", defaultValue: "This action cannot be undone.", comment: "Cannot undo message"))
        }
    }
}
