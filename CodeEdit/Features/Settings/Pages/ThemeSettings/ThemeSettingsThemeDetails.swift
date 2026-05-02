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
                        TextField(String(localized: "settings.theme.details.name", defaultValue: "Name", comment: "Theme details name field label"), text: $theme.displayName)
                        TextField(String(localized: "settings.theme.details.author", defaultValue: "Author", comment: "Theme details author field label"), text: $theme.author)
                        Picker(String(localized: "settings.theme.details.type", defaultValue: "Type", comment: "Theme details type picker label"), selection: $theme.appearance) {
                            Text(String(localized: "settings.theme.details.type.light", defaultValue: "Light", comment: "Theme details light type option"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "settings.theme.details.type.dark", defaultValue: "Dark", comment: "Theme details dark type option"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "settings.theme.details.section.text", defaultValue: "Text", comment: "Theme details text section header")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.text", defaultValue: "Text", comment: "Theme details text color picker label"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.cursor", defaultValue: "Cursor", comment: "Theme details cursor color picker label"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.invisibles", defaultValue: "Invisibles", comment: "Theme details invisibles color picker label"),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.section.background", defaultValue: "Background", comment: "Theme details background section header")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.background", defaultValue: "Background", comment: "Theme details background color picker label"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.current-line", defaultValue: "Current Line", comment: "Theme details current line color picker label"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.selection", defaultValue: "Selection", comment: "Theme details selection color picker label"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.section.tokens", defaultValue: "Tokens", comment: "Theme details tokens section header")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.keywords", defaultValue: "Keywords", comment: "Theme details keywords token label"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.commands", defaultValue: "Commands", comment: "Theme details commands token label"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.types", defaultValue: "Types", comment: "Theme details types token label"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.attributes", defaultValue: "Attributes", comment: "Theme details attributes token label"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.variables", defaultValue: "Variables", comment: "Theme details variables token label"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.values", defaultValue: "Values", comment: "Theme details values token label"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.numbers", defaultValue: "Numbers", comment: "Theme details numbers token label"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.strings", defaultValue: "Strings", comment: "Theme details strings token label"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.characters", defaultValue: "Characters", comment: "Theme details characters token label"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.token.comments", defaultValue: "Comments", comment: "Theme details comments token label"),
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
                        Image(systemName: String(localized: "settings.theme.details.warning.icon", defaultValue: "exclamationmark.triangle.fill", comment: "Theme details warning icon"))
                            .font(.body)
                            .foregroundStyle(Color.yellow)
                        Text(String(localized: "settings.theme.details.warning.message", defaultValue: "Duplicate this theme to make changes.", comment: "Theme details bundled theme warning message"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "settings.theme.details.warning.help", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Theme details bundled theme warning help text"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "settings.theme.details.warning.accessibility", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Theme details bundled theme warning accessibility label"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "settings.theme.details.delete-button", defaultValue: "Delete...", comment: "Theme details delete button"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "settings.theme.details.duplicate-button", defaultValue: "Duplicate...", comment: "Theme details duplicate button"))
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
                        Text(String(localized: "settings.theme.details.duplicate-bundled", defaultValue: "Duplicate", comment: "Theme details duplicate bundled theme button"))
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
                        Text(String(localized: "settings.theme.details.cancel-button", defaultValue: "Cancel", comment: "Theme details cancel button"))
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
                    Text(String(localized: "settings.theme.details.done-button", defaultValue: "Done", comment: "Theme details done button"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "settings.theme.details.delete-confirmation", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Theme details delete confirmation message"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "settings.theme.details.delete-theme-button", defaultValue: "Delete Theme", comment: "Theme details delete theme confirmation button")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "settings.theme.details.delete-cancel-button", defaultValue: "Cancel", comment: "Theme details delete cancel button")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.details.delete-warning", defaultValue: "This action cannot be undone.", comment: "Theme details delete warning message"))
        }
    }
}
