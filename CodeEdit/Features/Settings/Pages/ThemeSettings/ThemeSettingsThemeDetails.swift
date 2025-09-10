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
                        TextField("String(localized: "name", comment: "Label for theme name field")", text: $theme.displayString(localized: "name", comment: "Label for theme name field"))
                        TextField("String(localized: "author", comment: "Label for theme author field")", text: $theme.author)
                        Picker("String(localized: "type", comment: "Label for theme type picker")", selection: $theme.appearance) {
                            Text("Light")
                                .tag(Theme.ThemeType.light)
                            Text("Dark")
                                .tag(Theme.ThemeType.dark)
                        }
                    }
                    Section("Text") {
                        SettingsColorPicker(
                            "Text",
                            color: $theme.editor.text.swiftColor
                        )
                        SettingsColorPicker(
                            "String(localized: "cursor", comment: "Label for cursor color setting")",
                            color: $theme.editor.insertionPoint.swiftColor
                        )
                        SettingsColorPicker(
                            "Invisibles",
                            color: $theme.editor.invisibles.swiftColor
                        )
                    }
                    Section("String(localized: "background", comment: "Label for background color setting")") {
                        SettingsColorPicker(
                            "String(localized: "background", comment: "Label for background color setting")",
                            color: $theme.editor.background.swiftColor
                        )
                        SettingsColorPicker(
                            "String(localized: "current_line", comment: "Label for current line highlight color setting")",
                            color: $theme.editor.lineHighlight.swiftColor
                        )
                        SettingsColorPicker(
                            "Selection",
                            color: $theme.editor.selection.swiftColor
                        )
                    }
                    Section("String(localized: "tokens", comment: "Section header for syntax token color settings")") {
                        VStack(spacing: 0) {
                            ThemeSettingsThemeToken(
                                "String(localized: "keywords", comment: "Label for keywords syntax highlighting")",
                                color: $theme.editor.keywords.swiftColor,
                                bold: $theme.editor.keywords.bold,
                                italic: $theme.editor.keywords.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "commands", comment: "Label for commands syntax highlighting")",
                                color: $theme.editor.commands.swiftColor,
                                bold: $theme.editor.commands.bold,
                                italic: $theme.editor.commands.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "types", comment: "Label for types syntax highlighting")",
                                color: $theme.editor.types.swiftColor,
                                bold: $theme.editor.types.bold,
                                italic: $theme.editor.types.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "attributes", comment: "Label for attributes syntax highlighting")",
                                color: $theme.editor.attributes.swiftColor,
                                bold: $theme.editor.attributes.bold,
                                italic: $theme.editor.attributes.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "variables", comment: "Label for variables syntax highlighting")",
                                color: $theme.editor.variables.swiftColor,
                                bold: $theme.editor.variables.bold,
                                italic: $theme.editor.variables.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "values", comment: "Label for values syntax highlighting")",
                                color: $theme.editor.values.swiftColor,
                                bold: $theme.editor.values.bold,
                                italic: $theme.editor.values.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "numbers", comment: "Label for numbers syntax highlighting")",
                                color: $theme.editor.numbers.swiftColor,
                                bold: $theme.editor.numbers.bold,
                                italic: $theme.editor.numbers.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "strings", comment: "Label for strings syntax highlighting")",
                                color: $theme.editor.strings.swiftColor,
                                bold: $theme.editor.strings.bold,
                                italic: $theme.editor.strings.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "characters", comment: "Label for characters syntax highlighting")",
                                color: $theme.editor.characters.swiftColor,
                                bold: $theme.editor.characters.bold,
                                italic: $theme.editor.characters.italic
                            )
                            Divider().padding(.horizontal, 10)
                            ThemeSettingsThemeToken(
                                "String(localized: "comments", comment: "Label for comments syntax highlighting")",
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
                        Text("String(localized: "duplicate_theme_to_make_changes", comment: "Message indicating user needs to duplicate bundled theme to edit it")")
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .help("String(localized: "bundled_themes_must_be_duplicated", comment: "Help text explaining that bundled themes cannot be edited directly")")
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Warning: String(localized: "theme_duplicate_to_make_changes", comment: "Warning message for bundled themes that need duplication to edit")")
                } else if !themeModel.isAdding {
                    Button(role: .destructive) {
                        deleteConfirmationIsPresented = true
                    } label: {
                        Text("String(localized: "delete_ellipsis", comment: "Delete button text with ellipsis")")
                            .foregroundStyle(.red)
                            .frame(minWidth: 56)
                    }
                    Button {
                        if let fileURL = theme.fileURL {
                            duplicatingTheme = theme
                            themeModel.duplicate(fileURL)
                        }
                    } label: {
                        Text("String(localized: "duplicate_ellipsis", comment: "Duplicate button text with ellipsis")")
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
                        Text("String(localized: "duplicate", comment: "Duplicate button text")")
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
                        Text("String(localized: "cancel", comment: "Cancel button text")")
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
                    Text("String(localized: "done", comment: "Done button text")")
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .constrainHeightToWindow()
        .alert(
            Text("Are you sure you want to delete the theme “\(theme.displayName)”?"),
            isPresented: $deleteConfirmationIsPresented
        ) {
            Button("String(localized: "delete_theme", comment: "Delete theme button text")") {
                themeModel.delete(theme)
                dismiss()
            }
            Button("String(localized: "cancel", comment: "Cancel button text")") {
                deleteConfirmationIsPresented = false
            }
        } message: {
            Text("String(localized: "action_cannot_be_undone", comment: "Warning message about irreversible action")")
        }
    }
}
