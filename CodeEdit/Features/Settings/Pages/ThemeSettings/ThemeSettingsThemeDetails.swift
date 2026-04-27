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
                        TextField(String(localized: "theme-details.field.name", defaultValue: "Name", comment: "Text field label for theme name"), text: $theme.displayName)
                        TextField(String(localized: "theme-details.field.author", defaultValue: "Author", comment: "Text field label for theme author"), text: $theme.author)
                        Picker(String(localized: "theme-details.picker.type", defaultValue: "Type", comment: "Picker label for theme type"), selection: $theme.appearance) {
                            Text(String(localized: "theme-details.type.light", defaultValue: "Light", comment: "Theme type option for light"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "theme-details.type.dark", defaultValue: "Dark", comment: "Theme type option for dark"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "theme-details.section.text", defaultValue: "Text", comment: "Section header for text colors")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.color.text", defaultValue: "Text", comment: "Color picker label for text color"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            "Cursor",
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.background", defaultValue: "Background", comment: "Section header for background colors")) {
                        SettingsColorPicker(
                            String(localized: "theme-details.color.background", defaultValue: "Background", comment: "Color picker label for background color"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            "Current Line",
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            "Selection",
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "theme-details.section.tokens", defaultValue: "Tokens", comment: "Section header for token colors")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                "Keywords",
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Commands",
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Types",
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Attributes",
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Variables",
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Values",
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Numbers",
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Strings",
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Characters",
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "Comments",
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
                        Text(String(localized: "theme-details.warning.duplicate", defaultValue: "Duplicate this theme to make changes.", comment: "Warning message for bundled theme"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "theme-details.help.bundled-duplicate", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Help text for bundled theme warning"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "theme-details.accessibility.duplicate-warning", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Accessibility label for duplicate warning"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "theme-details.button.delete", defaultValue: "Delete...", comment: "Button to delete theme"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "theme-details.button.duplicate", defaultValue: "Duplicate...", comment: "Button to duplicate theme"))
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
                        Text(String(localized: "theme-details.button.duplicate-action", defaultValue: "Duplicate", comment: "Button to duplicate bundled theme"))
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
                        Text(String(localized: "theme-details.button.cancel", defaultValue: "Cancel", comment: "Button to cancel theme editing"))
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
                    Text(String(localized: "theme-details.button.done", defaultValue: "Done", comment: "Button to finish theme editing"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "theme-details.alert.title", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Alert title for theme deletion confirmation"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "theme-details.alert.delete-theme", defaultValue: "Delete Theme", comment: "Alert button to confirm theme deletion")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "theme-details.alert.cancel", defaultValue: "Cancel", comment: "Alert button to cancel theme deletion")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "theme-details.alert.message", defaultValue: "This action cannot be undone.", comment: "Alert message warning about theme deletion"))
        }
    }
}
