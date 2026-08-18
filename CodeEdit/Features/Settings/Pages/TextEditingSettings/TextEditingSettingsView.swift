//
//  TextEditingSettingsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/2/23.
//

import SwiftUI

/// A view that implements the `Text Editing` settings page
struct TextEditingSettingsView: View {
    @AppSettings(\.textEditing)
    var textEditing

    @State private var isShowingInvisibleCharacterSettings = false
    @State private var isShowingWarningCharactersSettings = false

    var body: some View {
        SettingsForm {
            Section {
                indentOption
                defaultTabWidth
                wrapLinesToEditorWidth
                useSystemCursor
                overscroll
            }
            Section {
                showGutter
                showMinimap
                showFoldingRibbon
                reformatSettings
            }
            Section {
                fontSelector
                fontSizeSelector
                fontWeightSelector
                lineHeight
                letterSpacing
            }
            Section {
                autocompleteBraces
                enableTypeOverCompletion
            }
            Section {
                bracketPairHighlight
            }
            Section {
                invisibles
                warningCharacters
            }
        }
    }
}

private extension TextEditingSettingsView {
    @ViewBuilder private var fontSelector: some View {
        MonospacedFontPicker(title: String(
            localized: "settings.text-editing.view.font.label",
            defaultValue: "Font",
            comment: "Label for editor font selection in text editing settings"
        ), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(
                localized: "settings.text-editing.view.font-size.label",
                defaultValue: "Font Size",
                comment: "Label for editor font size setting"
            ),
            value: $textEditing.font.size,
            in: 1...288,
            step: 1,
            format: .number
        )
    }

    @ViewBuilder private var fontWeightSelector: some View {
        FontWeightPicker(selection: $textEditing.font.weight)
    }

    @ViewBuilder private var autocompleteBraces: some View {
        Toggle(isOn: $textEditing.autocompleteBraces) {
            Text(String(
                localized: "settings.text-editing.view.autocomplete-braces.title",
                defaultValue: "Autocomplete braces",
                comment: "Section title for autocomplete braces setting"
            ))
            Text(String(
                localized: "settings.text-editing.view.autocomplete-braces.description",
                defaultValue: "Automatically insert closing braces (\"}\")",
                comment: "Description for automatic closing brace insertion"
            ))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(
            localized: "settings.text-editing.view.type-over-completion.toggle",
            defaultValue: "Enable type-over completion",
            comment: "Toggle label for type-over completion"
        ), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(
            localized: "settings.text-editing.view.wrap-lines-to-editor-width.toggle",
            defaultValue: "Wrap lines to editor width",
            comment: "Toggle label for wrapping lines to editor width"
        ), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(
                localized: "settings.text-editing.view.use-system-cursor.toggle",
                defaultValue: "Use System Cursor",
                comment: "Toggle label for using system cursor"
            ), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(
                    localized: "settings.text-editing.view.editor-overscroll.label",
                    defaultValue: "Editor Overscroll",
                    comment: "Label for editor overscroll setting"
                ),
                selection: $textEditing.overscroll
            ) {
                Text(String(
                    localized: "settings.text-editing.view.editor-overscroll.none.option",
                    defaultValue: "None",
                    comment: "Option title for no editor overscroll"
                ))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(
                    localized: "settings.text-editing.view.editor-overscroll.small.option",
                    defaultValue: "Small",
                    comment: "Option title for small editor overscroll"
                ))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(
                    localized: "settings.text-editing.view.editor-overscroll.medium.option",
                    defaultValue: "Medium",
                    comment: "Option title for medium editor overscroll"
                ))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(
                    localized: "settings.text-editing.view.editor-overscroll.large.option",
                    defaultValue: "Large",
                    comment: "Option title for large editor overscroll"
                ))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(
                localized: "settings.text-editing.view.line-height.label",
                defaultValue: "Line Height",
                comment: "Label for line height setting"
            ),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(
                localized: "settings.text-editing.view.prefer-indent-using.label",
                defaultValue: "Prefer Indent Using",
                comment: "Label for preferred indentation method"
            ), selection: $textEditing.indentOption.indentType) {
                Text(String(
                    localized: "settings.text-editing.view.prefer-indent-using.tabs.option",
                    defaultValue: "Tabs",
                    comment: "Option title for tab-based indentation"
                ))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(
                    localized: "settings.text-editing.view.prefer-indent-using.spaces.option",
                    defaultValue: "Spaces",
                    comment: "Option title for space-based indentation"
                ))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(
                            localized: "settings.text-editing.view.indent-width.label",
                            defaultValue: "Indent Width",
                            comment: "Label for indent width setting"
                        ),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(
                        localized: "settings.text-editing.view.indent-width.spaces.unit",
                        defaultValue: "spaces",
                        comment: "Unit label for indent width measured in spaces"
                    ))
                        .foregroundColor(.secondary)
                }
                .help(String(
                    localized: "settings.text-editing.view.indent-width.description",
                    defaultValue: "The number of spaces to insert when the tab key is pressed.",
                    comment: "Description for indent width behavior"
                ))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(
                    localized: "settings.text-editing.view.tab-width.label",
                    defaultValue: "Tab Width",
                    comment: "Label for tab width setting"
                ),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(
                localized: "settings.text-editing.view.tab-width.spaces.unit",
                defaultValue: "spaces",
                comment: "Unit label for tab width measured in spaces"
            ))
                .foregroundColor(.secondary)
        }
        .help(String(
            localized: "settings.text-editing.view.tab-width.description",
            defaultValue: "The visual width of tabs.",
            comment: "Description for tab width setting"
        ))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(
                localized: "settings.text-editing.view.letter-spacing.label",
                defaultValue: "Letter Spacing",
                comment: "Label for letter spacing setting"
            ),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.label",
                    defaultValue: "Bracket Pair Highlight",
                    comment: "Label for bracket pair highlight style setting"
                ),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.disabled.option",
                    defaultValue: "Disabled",
                    comment: "Option title for disabled bracket pair highlight style"
                )).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.bordered.option",
                    defaultValue: "Bordered",
                    comment: "Option title for bordered bracket pair highlight style"
                )).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.flash.option",
                    defaultValue: "Flash",
                    comment: "Option title for flash bracket pair highlight style"
                )).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.underline.option",
                    defaultValue: "Underline",
                    comment: "Option title for underline bracket pair highlight style"
                )).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(
                    localized: "settings.text-editing.view.bracket-pair-highlight.use-custom-color.toggle",
                    defaultValue: "Use Custom Color",
                    comment: "Toggle label for using custom bracket pair highlight color"
                ), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(
                        localized: "settings.text-editing.view.bracket-pair-highlight.color.label",
                        defaultValue: "Bracket Pair Highlight Color",
                        comment: "Label for bracket pair highlight color picker"
                    ),
                    color: $textEditing.bracketEmphasis.color.swiftColor
                )
                .foregroundColor(
                    textEditing.bracketEmphasis.useCustomColor
                        ? Color(.labelColor)
                        : Color(.secondaryLabelColor)
                )
                .disabled(!textEditing.bracketEmphasis.useCustomColor)
            }
        }
    }

    @ViewBuilder private var showGutter: some View {
        Toggle(String(
            localized: "settings.text-editing.view.show-gutter.toggle",
            defaultValue: "Show Gutter",
            comment: "Toggle label for showing editor gutter"
        ), isOn: $textEditing.showGutter)
            .help(String(
                localized: "settings.text-editing.view.show-gutter.description",
                defaultValue: "The gutter displays line numbers and code folding regions.",
                comment: "Description for gutter visibility setting"
            ))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(
            localized: "settings.text-editing.view.show-minimap.toggle",
            defaultValue: "Show Minimap",
            comment: "Toggle label for showing minimap"
        ), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(
                localized: "settings.text-editing.view.show-minimap.description",
                defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.",
                comment: "Description for minimap visibility setting"
            ))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(
            localized: "settings.text-editing.view.show-code-folding-ribbon.toggle",
            defaultValue: "Show Code Folding Ribbon",
            comment: "Toggle label for showing code folding ribbon"
        ), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(
                localized: "settings.text-editing.view.show-code-folding-ribbon.description",
                defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.",
                comment: "Description for code folding ribbon setting"
            ))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(
            localized: "settings.text-editing.view.show-reformatting-guide.toggle",
            defaultValue: "Show Reformatting Guide",
            comment: "Toggle label for showing reformatting guide"
        ), isOn: $textEditing.showReformattingGuide)
            .help(String(
                localized: "settings.text-editing.view.show-reformatting-guide.description",
                defaultValue: "Shows a vertical guide at the reformat column.",
                comment: "Description for reformatting guide setting"
            ))

        Stepper(
            String(
                localized: "settings.text-editing.view.reformat-at-column.label",
                defaultValue: "Reformat at Column",
                comment: "Label for reformat column setting"
            ),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(
            localized: "settings.text-editing.view.reformat-at-column.description",
            defaultValue: "The column at which text should be reformatted.",
            comment: "Description for reformat column value"
        ))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(
                localized: "settings.text-editing.show-invisible-characters",
                defaultValue: "Show Invisible Characters",
                comment: "Text editing settings toggle label for invisible characters"
            ))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(
                    localized: "settings.text-editing.invisible-characters.configure",
                    defaultValue: "Configure...",
                    comment: "Button title to configure invisible character display settings"
                ))
            }
            .disabled(textEditing.invisibleCharacters.enabled == false)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if textEditing.invisibleCharacters.enabled {
                isShowingInvisibleCharacterSettings = true
            }
        }
        .sheet(isPresented: $isShowingInvisibleCharacterSettings) {
            InvisiblesSettingsView(invisibleCharacters: $textEditing.invisibleCharacters)
        }
    }

    @ViewBuilder private var warningCharacters: some View {
        HStack {
            Text(String(
                localized: "settings.text-editing.show-warning-characters",
                defaultValue: "Show Warning Characters",
                comment: "Text editing settings toggle label for warning characters"
            ))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(
                    localized: "settings.text-editing.warning-characters.configure",
                    defaultValue: "Configure...",
                    comment: "Button title to configure warning character settings"
                ))
            }
            .disabled(textEditing.warningCharacters.enabled == false)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if textEditing.warningCharacters.enabled {
                isShowingWarningCharactersSettings = true
            }
        }
        .sheet(isPresented: $isShowingWarningCharactersSettings) {
            WarningCharactersView(warningCharacters: $textEditing.warningCharacters)
        }
    }
}
