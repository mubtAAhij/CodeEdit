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
                        TextField(String(
                            localized: "theme-settings-details.name",
                            defaultValue: "Name",
                            comment: "Label for theme name field"
                        ), text: $theme.displayName)
                        TextField(String(
                            localized: "theme-settings-details.author",
                            defaultValue: "Author",
                            comment: "Label for theme author field"
                        ), text: $theme.author)
                        Picker(String(
                            localized: "theme-settings-details.type",
                            defaultValue: "Type",
                            comment: "Label for theme type picker"
                        ), selection: $theme.appearance) {
                            Text(String(
                                localized: "theme-settings-details.type.light",
                                defaultValue: "Light",
                                comment: "Light theme type option"
                            ))
                                .tag(Theme.ThemeType.light)
                            Text(String(
                                localized: "theme-settings-details.type.dark",
                                defaultValue: "Dark",
                                comment: "Dark theme type option"
                            ))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section("Text") {
                        SettingsColorPicker(
                            "Text",
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "theme-settings-details.cursor",
                                defaultValue: "Cursor",
                                comment: "Label for cursor color picker"
                            ),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(
                        localized: "theme-settings-details.background-section",
                        defaultValue: "Background",
                        comment: "Section header for background colors"
                    )) {
                        SettingsColorPicker(
                            String(
                                localized: "theme-settings-details.background",
                                defaultValue: "Background",
                                comment: "Label for background color picker"
                            ),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "theme-settings-details.current-line",
                                defaultValue: "Current Line",
                                comment: "Label for current line highlight color picker"
                            ),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "theme-settings-details.selection",
                                defaultValue: "Selection",
                                comment: "Label for selection color picker"
                            ),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(
                        localized: "theme-settings-details.tokens",
                        defaultValue: "Tokens",
                        comment: "Section header for syntax tokens"
                    )) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.keywords",
                                    defaultValue: "Keywords",
                                    comment: "Label for keywords token"
                                ),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.commands",
                                    defaultValue: "Commands",
                                    comment: "Label for commands token"
                                ),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.types",
                                    defaultValue: "Types",
                                    comment: "Label for types token"
                                ),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.attributes",
                                    defaultValue: "Attributes",
                                    comment: "Label for attributes token"
                                ),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.variables",
                                    defaultValue: "Variables",
                                    comment: "Label for variables token"
                                ),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.values",
                                    defaultValue: "Values",
                                    comment: "Label for values token"
                                ),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.numbers",
                                    defaultValue: "Numbers",
                                    comment: "Label for numbers token"
                                ),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.strings",
                                    defaultValue: "Strings",
                                    comment: "Label for strings token"
                                ),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.characters",
                                    defaultValue: "Characters",
                                    comment: "Label for characters token"
                                ),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "theme-settings-details.comments",
                                    defaultValue: "Comments",
                                    comment: "Label for comments token"
                                ),
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
                        Text(String(
                            localized: "theme-settings-details.duplicate-to-change",
                            defaultValue: "Duplicate this theme to make changes.",
                            comment: "Warning message for bundled themes"
                        ))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(
                        localized: "theme-settings-details.bundled-themes-help",
                        defaultValue: "Bundled themes must be duplicated to make changes.",
                        comment: "Help text for bundled themes restriction"
                    ))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(
                        localized: "theme-settings-details.warning-duplicate",
                        defaultValue: "Warning: Duplicate this theme to make changes.",
                        comment: "Accessibility label for bundled theme warning"
                    ))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(
                            localized: "theme-settings-details.delete",
                            defaultValue: "Delete...",
                            comment: "Button to delete theme"
                        ))
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text(String(
                            localized: "theme-settings-details.duplicate-ellipsis",
                            defaultValue: "Duplicate...",
                            comment: "Button to duplicate theme with ellipsis"
                        ))
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
                        Text(String(
                            localized: "theme-settings-details.duplicate-no-ellipsis",
                            defaultValue: "Duplicate",
                            comment: "Button to duplicate theme without ellipsis"
                        ))
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
                        Text(String(
                            localized: "theme-settings-details.cancel",
                            defaultValue: "Cancel",
                            comment: "Cancel button"
                        ))
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
                    Text(String(
                        localized: "theme-settings-details.done",
                        defaultValue: "Done",
                        comment: "Done button"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            {
                let themeName = theme.displayName
                return Text(String(
                    localized: "theme-settings-details.delete-confirmation",
                    defaultValue: "Are you sure you want to delete the theme \"\(themeName)\"?",
                    comment: "Confirmation message for theme deletion"
                ))
            }(),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(
                localized: "theme-settings-details.delete-theme",
                defaultValue: "Delete Theme",
                comment: "Button to confirm theme deletion"
            )) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(
                localized: "theme-settings-details.cancel-delete",
                defaultValue: "Cancel",
                comment: "Cancel deletion button"
            )) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(
                localized: "theme-settings-details.cannot-undo",
                defaultValue: "This action cannot be undone.",
                comment: "Warning that deletion is permanent"
            ))
        }
    }
}
