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
                        TextField(String(localized: "settings.theme.details.name", defaultValue: "Name", comment: "TextField label for theme name"), text: $theme.displayName)
                        TextField(String(localized: "settings.theme.details.author", defaultValue: "Author", comment: "TextField label for theme author"), text: $theme.author)
                        Picker(String(localized: "settings.theme.details.type", defaultValue: "Type", comment: "Picker label for theme type"), selection: $theme.appearance) {
                            Text(String(localized: "settings.theme.details.type.light", defaultValue: "Light", comment: "Theme type option for light appearance"))
                                .tag(Theme.ThemeType.light)
                            Text(String(localized: "settings.theme.details.type.dark", defaultValue: "Dark", comment: "Theme type option for dark appearance"))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(localized: "settings.theme.details.section.text", defaultValue: "Text", comment: "Section header for text-related theme settings")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.text.text", defaultValue: "Text", comment: "Color picker label for text color"),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.text.cursor", defaultValue: "Cursor", comment: "Color picker label for cursor color"),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.text.invisibles", defaultValue: "Invisibles", comment: "Color picker label for invisible characters color"),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.section.background", defaultValue: "Background", comment: "Section header for background-related theme settings")) {
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.background.background", defaultValue: "Background", comment: "Color picker label for background color"),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.background.current-line", defaultValue: "Current Line", comment: "Color picker label for current line highlight color"),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(localized: "settings.theme.details.background.selection", defaultValue: "Selection", comment: "Color picker label for selection color"),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(localized: "settings.theme.details.section.tokens", defaultValue: "Tokens", comment: "Section header for token syntax highlighting settings")) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.keywords", defaultValue: "Keywords", comment: "Token type label for keywords"),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.commands", defaultValue: "Commands", comment: "Token type label for commands"),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.types", defaultValue: "Types", comment: "Token type label for types"),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.attributes", defaultValue: "Attributes", comment: "Token type label for attributes"),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.variables", defaultValue: "Variables", comment: "Token type label for variables"),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.values", defaultValue: "Values", comment: "Token type label for values"),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.numbers", defaultValue: "Numbers", comment: "Token type label for numbers"),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.strings", defaultValue: "Strings", comment: "Token type label for strings"),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.characters", defaultValue: "Characters", comment: "Token type label for characters"),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(localized: "settings.theme.details.tokens.comments", defaultValue: "Comments", comment: "Token type label for comments"),
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
                        Text(String(localized: "settings.theme.details.bundled-theme-warning", defaultValue: "Duplicate this theme to make changes.", comment: "Warning message shown for bundled themes"))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(localized: "settings.theme.details.bundled-theme-tooltip", defaultValue: "Bundled themes must be duplicated to make changes.", comment: "Tooltip explaining bundled theme restrictions"))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(localized: "settings.theme.details.bundled-theme-accessibility", defaultValue: "Warning: Duplicate this theme to make changes.", comment: "Accessibility label for bundled theme warning"))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(localized: "settings.theme.details.button.delete", defaultValue: "Delete...", comment: "Button label to delete a theme"))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(localized: "settings.theme.details.button.duplicate-ellipsis", defaultValue: "Duplicate...", comment: "Button label to duplicate a theme (with ellipsis)"))
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
                        Text(String(localized: "settings.theme.details.button.duplicate", defaultValue: "Duplicate", comment: "Button label to duplicate a theme"))
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
                        Text(String(localized: "settings.theme.details.button.cancel", defaultValue: "Cancel", comment: "Button label to cancel theme editing"))
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
                    Text(String(localized: "settings.theme.details.button.done", defaultValue: "Done", comment: "Button label to finish theme editing"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(localized: "settings.theme.details.delete-confirmation-title", defaultValue: "Are you sure you want to delete the theme \"%@\"?", comment: "Alert title confirming theme deletion"), theme.displayName)),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(localized: "settings.theme.details.delete-confirmation-delete", defaultValue: "Delete Theme", comment: "Button label to confirm theme deletion")) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(localized: "settings.theme.details.delete-confirmation-cancel", defaultValue: "Cancel", comment: "Button label to cancel theme deletion")) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(localized: "settings.theme.details.delete-confirmation-message", defaultValue: "This action cannot be undone.", comment: "Alert message warning that theme deletion is permanent"))
        }
    }
}
