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
                            localized: "settings.theme.theme-details.name",
                            defaultValue: "Name",
                            comment: "Theme details field label for theme name"
                        ), text: $theme.displayName)
                        TextField(String(
                            localized: "settings.theme.theme-details.author",
                            defaultValue: "Author",
                            comment: "Theme details field label for theme author"
                        ), text: $theme.author)
                        Picker(String(
                            localized: "settings.theme.theme-details.type",
                            defaultValue: "Type",
                            comment: "Theme details field label for theme type"
                        ), selection: $theme.appearance) {
                            Text(String(
                                localized: "settings.theme.theme-details.type.light",
                                defaultValue: "Light",
                                comment: "Theme type value for light themes"
                            ))
                                .tag(Theme.ThemeType.light)
                            Text(String(
                                localized: "settings.theme.theme-details.type.dark",
                                defaultValue: "Dark",
                                comment: "Theme type value for dark themes"
                            ))
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section(String(
                        localized: "settings.theme.theme-details.preview.text.primary",
                        defaultValue: "Text",
                        comment: "Theme preview section label for primary text color"
                    )) {
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.text.secondary",
                                defaultValue: "Text",
                                comment: "Theme preview section label for secondary text color"
                            ),
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.cursor",
                                defaultValue: "Cursor",
                                comment: "Theme preview section label for cursor color"
                            ),
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.invisibles",
                                defaultValue: "Invisibles",
                                comment: "Theme preview section label for invisibles color"
                            ),
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section(String(
                        localized: "settings.theme.theme-details.preview.background.primary",
                        defaultValue: "Background",
                        comment: "Theme preview section label for primary background color"
                    )) {
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.background.secondary",
                                defaultValue: "Background",
                                comment: "Theme preview section label for secondary background color"
                            ),
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.current-line",
                                defaultValue: "Current Line",
                                comment: "Theme preview section label for current line color"
                            ),
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            String(
                                localized: "settings.theme.theme-details.preview.selection",
                                defaultValue: "Selection",
                                comment: "Theme preview section label for selection color"
                            ),
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section(String(
                        localized: "settings.theme.theme-details.preview.tokens",
                        defaultValue: "Tokens",
                        comment: "Theme preview section label for token colors"
                    )) {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.keywords",
                                    defaultValue: "Keywords",
                                    comment: "Theme preview token category label for keywords"
                                ),
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.commands",
                                    defaultValue: "Commands",
                                    comment: "Theme preview token category label for commands"
                                ),
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.types",
                                    defaultValue: "Types",
                                    comment: "Theme preview token category label for types"
                                ),
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.attributes",
                                    defaultValue: "Attributes",
                                    comment: "Theme preview token category label for attributes"
                                ),
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.variables",
                                    defaultValue: "Variables",
                                    comment: "Theme preview token category label for variables"
                                ),
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.values",
                                    defaultValue: "Values",
                                    comment: "Theme preview token category label for values"
                                ),
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.numbers",
                                    defaultValue: "Numbers",
                                    comment: "Theme preview token category label for numbers"
                                ),
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.strings",
                                    defaultValue: "Strings",
                                    comment: "Theme preview token category label for strings"
                                ),
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.characters",
                                    defaultValue: "Characters",
                                    comment: "Theme preview token category label for characters"
                                ),
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                String(
                                    localized: "settings.theme.theme-details.preview.tokens.comments",
                                    defaultValue: "Comments",
                                    comment: "Theme preview token category label for comments"
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
                            localized: "settings.theme.theme-details.duplicate-to-edit",
                            defaultValue: "Duplicate this theme to make changes.",
                            comment: "Instruction shown when theme must be duplicated before editing"
                        ))
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help(String(
                        localized: "settings.theme.theme-details.bundled-theme-duplicate-required",
                        defaultValue: "Bundled themes must be duplicated to make changes.",
                        comment: "Warning explaining bundled themes require duplication for edits"
                    ))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(String(
                        localized: "settings.theme.theme-details.warning-duplicate-to-edit",
                        defaultValue: "Warning: Duplicate this theme to make changes.",
                        comment: "Warning banner text indicating duplication is required before editing"
                    ))
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text(String(
                            localized: "settings.theme.theme-details.delete",
                            defaultValue: "Delete...",
                            comment: "Button title to delete theme"
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
                            localized: "settings.theme.theme-details.duplicate",
                            defaultValue: "Duplicate...",
                            comment: "Button title to duplicate theme"
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
                            localized: "settings.theme.theme-details.duplicate.confirm",
                            defaultValue: "Duplicate",
                            comment: "Confirmation button title for duplicating theme"
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
                            localized: "settings.theme.theme-details.cancel",
                            defaultValue: "Cancel",
                            comment: "Cancel button title in theme details dialog"
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
                        localized: "settings.theme.theme-details.done",
                        defaultValue: "Done",
                        comment: "Done button title in theme details view"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text(String(format: String(
                localized: "settings.theme.theme-details.delete-confirmation.question",
                defaultValue: "Are you sure you want to delete the theme “%@”?",
                comment: "Delete confirmation prompt showing theme name"
            ), "\(theme.displayName)")),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button(String(
                localized: "settings.theme.theme-details.delete-confirmation.title",
                defaultValue: "Delete Theme",
                comment: "Delete confirmation title for theme"
            )) {
                themeModel.delete(theme)
                dismiss()
            }
            Button(String(
                localized: "settings.theme.theme-details.delete-confirmation.cancel",
                defaultValue: "Cancel",
                comment: "Cancel button title in delete theme confirmation"
            )) {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text(String(
                localized: "settings.theme.theme-details.delete-confirmation.cannot-undo",
                defaultValue: "This action cannot be undone.",
                comment: "Delete confirmation warning that action cannot be undone"
            ))
        }
    }
}
