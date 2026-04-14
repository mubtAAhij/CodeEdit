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
                        TextField(String(localized: "name", defaultValue: "Name", comment: "Name field label"), text: $theme.displayName)
                        TextField(String(localized: "author", defaultValue: "Author", comment: "Author field label", os_id: "102558"), text: $theme.author)
                        Picker(String(localized: "type", defaultValue: "Type", comment: "Type picker label", os_id: "102038"), selection: $theme.appearance) {
                            Text(String(localized: "light", defaultValue: "Light", comment: "Light theme type"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "dark", defaultValue: "Dark", comment: "Dark theme type", os_id: "102374"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "text", defaultValue: "Text", comment: "Text section title")) {
                        SettingsColorPicker(
                            String(localized: "text", defaultValue: "Text", comment: "Text color picker label", os_id: "102057"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "cursor", defaultValue: "Cursor", comment: "Cursor color picker label", os_id: "102559"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "background", defaultValue: "Background", comment: "Background section title")) {
                        SettingsColorPicker(
                            String(localized: "background", defaultValue: "Background", comment: "Background color picker label", os_id: "102560"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "current-line", defaultValue: "Current Line", comment: "Current line color picker label", os_id: "102561"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "selection", defaultValue: "Selection", comment: "Selection color picker label", os_id: "102562"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "tokens", defaultValue: "Tokens", comment: "Tokens section title", os_id: "102563")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "keywords", defaultValue: "Keywords", comment: "Keywords token label", os_id: "102564"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "commands", defaultValue: "Commands", comment: "Commands token label", os_id: "101939"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "types", defaultValue: "Types", comment: "Types token label", os_id: "102565"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "attributes", defaultValue: "Attributes", comment: "Attributes token label", os_id: "102566"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "variables", defaultValue: "Variables", comment: "Variables token label", os_id: "102567"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "values", defaultValue: "Values", comment: "Values token label", os_id: "102568"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "numbers", defaultValue: "Numbers", comment: "Numbers token label", os_id: "102569"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "strings", defaultValue: "Strings", comment: "Strings token label", os_id: "102570"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "characters", defaultValue: "Characters", comment: "Characters token label", os_id: "102571"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "comments", defaultValue: "Comments", comment: "Comments token label", os_id: "102572"),
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
                        Text(String(localized: "duplicate-theme-to-edit", defaultValue: "Duplicate this theme to make changes.", comment: "Duplicate theme to edit message", os_id: "102573"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "bundled-themes-must-duplicate", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Bundled themes must duplicate help text", os_id: "102574"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "warning-duplicate-theme", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Warning duplicate theme accessibility label", os_id: "102575"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "delete-ellipsis", defaultValue: "Delete...", comment: "Delete button", os_id: "102250"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Duplicate button", os_id: "102553"))
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
                        Text(String(localized: "duplicate", defaultValue: "Duplicate", comment: "Duplicate button", os_id: "102576"))
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
            Text(String(format: String(localized: "confirm-delete-theme", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Confirm delete theme alert", os_id: "102555"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "delete-theme", defaultValue: "Delete Theme", comment: "Delete theme button", os_id: "102556")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "action-cannot-be-undone", defaultValue: "This action cannot be undone.", comment: "Action cannot be undone message"))
        }
    }
}
