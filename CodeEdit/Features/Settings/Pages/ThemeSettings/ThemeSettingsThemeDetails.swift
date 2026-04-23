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
                        TextField(String(localized: "theme-details.name", defaultValue: "Name", comment: "Name field label", os_id: "106108"), text: $theme.displayName)
                        TextField(String(localized: "theme-details.author", defaultValue: "Author", comment: "Author field label", os_id: "106109"), text: $theme.author)
                        Picker(String(localized: "theme-details.type", defaultValue: "Type", comment: "Type picker label", os_id: "106110"), selection: $theme.appearance) {
                            Text(String(localized: "theme-details.light", defaultValue: "Light", comment: "Light theme type"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme-details.dark", defaultValue: "Dark", comment: "Dark theme type", os_id: "105931"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme-details.text-section", defaultValue: "Text", comment: "Text section label")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.text", defaultValue: "Text", comment: "Text color label", os_id: "106111"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.cursor", defaultValue: "Cursor", comment: "Cursor color label", os_id: "106112"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.background-section", defaultValue: "Background", comment: "Background section label")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.background", defaultValue: "Background", comment: "Background color label", os_id: "106113"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.current-line", defaultValue: "Current Line", comment: "Current line color label", os_id: "106114"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "theme-details.selection", defaultValue: "Selection", comment: "Selection color label", os_id: "106115"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.tokens", defaultValue: "Tokens", comment: "Tokens section label", os_id: "106116")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.keywords", defaultValue: "Keywords", comment: "Keywords token label", os_id: "106117"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.commands", defaultValue: "Commands", comment: "Commands token label", os_id: "106118"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.types", defaultValue: "Types", comment: "Types token label", os_id: "106119"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.attributes", defaultValue: "Attributes", comment: "Attributes token label", os_id: "106120"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.variables", defaultValue: "Variables", comment: "Variables token label", os_id: "106121"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.values", defaultValue: "Values", comment: "Values token label", os_id: "106122"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.numbers", defaultValue: "Numbers", comment: "Numbers token label", os_id: "106123"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.strings", defaultValue: "Strings", comment: "Strings token label", os_id: "106124"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.characters", defaultValue: "Characters", comment: "Characters token label", os_id: "106125"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "theme-details.comments", defaultValue: "Comments", comment: "Comments token label", os_id: "106126"),
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
                        Text(String(localized: "theme-details.duplicate-to-change", defaultValue: "Duplicate this theme to make changes.", comment: "Duplicate theme to change message", os_id: "106127"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme-details.bundled-duplicate-help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Bundled themes help text", os_id: "106128"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme-details.warning-duplicate", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Warning accessibility label", os_id: "106129"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme-details.delete-ellipsis", defaultValue: "Delete...", comment: "Delete button with ellipsis", os_id: "106104"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme-details.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Duplicate button with ellipsis", os_id: "106102"))
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
                        Text(String(localized: "theme-details.duplicate", defaultValue: "Duplicate", comment: "Duplicate button", os_id: "106130"))
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
            Text(String(format: String(localized: "theme-details.delete-confirm", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Delete theme confirmation", os_id: "106105"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-details.delete-theme", defaultValue: "Delete Theme", comment: "Delete theme button", os_id: "106106")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme-details.cancel-delete", defaultValue: "Cancel", comment: "Cancel delete button", os_id: "105852")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-details.cannot-undo", defaultValue: "This action cannot be undone.", comment: "Cannot undo message", os_id: "106107"))
        }
    }
}
