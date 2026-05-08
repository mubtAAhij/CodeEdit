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
        MonospacedFontPicker(title: String(localized: "settings.text_editing.font", defaultValue: "Font", comment: "Label for font selector"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text_editing.font_size", defaultValue: "Font Size", comment: "Label for font size stepper"),
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
            Text(String(localized: "settings.text_editing.autocomplete_braces", defaultValue: "Autocomplete braces", comment: "Toggle label for autocomplete braces"))
            Text(String(localized: "settings.text_editing.autocomplete_braces_description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description for autocomplete braces toggle"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text_editing.enable_type_over_completion", defaultValue: "Enable type-over completion", comment: "Toggle label for type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text_editing.wrap_lines_to_editor_width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for line wrapping"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text_editing.use_system_cursor", defaultValue: "Use System Cursor", comment: "Toggle label for system cursor"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text_editing.editor_overscroll", defaultValue: "Editor Overscroll", comment: "Label for overscroll picker"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text_editing.overscroll.none", defaultValue: "None", comment: "Overscroll option: none"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text_editing.overscroll.small", defaultValue: "Small", comment: "Overscroll option: small"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text_editing.overscroll.medium", defaultValue: "Medium", comment: "Overscroll option: medium"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text_editing.overscroll.large", defaultValue: "Large", comment: "Overscroll option: large"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text_editing.line_height", defaultValue: "Line Height", comment: "Label for line height stepper"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text_editing.prefer_indent_using", defaultValue: "Prefer Indent Using", comment: "Label for indent type picker"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text_editing.indent.tabs", defaultValue: "Tabs", comment: "Indent option: tabs"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text_editing.indent.spaces", defaultValue: "Spaces", comment: "Indent option: spaces"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text_editing.indent_width", defaultValue: "Indent Width", comment: "Label for indent width stepper"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text_editing.spaces_unit", defaultValue: "spaces", comment: "Unit label for spaces"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text_editing.indent_width_help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text_editing.tab_width", defaultValue: "Tab Width", comment: "Label for tab width stepper"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text_editing.spaces_unit", defaultValue: "spaces", comment: "Unit label for spaces"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text_editing.tab_width_help", defaultValue: "The visual width of tabs.", comment: "Help text for tab width"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text_editing.letter_spacing", defaultValue: "Letter Spacing", comment: "Label for letter spacing stepper"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text_editing.bracket_pair_highlight", defaultValue: "Bracket Pair Highlight", comment: "Label for bracket pair highlight picker"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text_editing.bracket_highlight.disabled", defaultValue: "Disabled", comment: "Bracket highlight option: disabled")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text_editing.bracket_highlight.bordered", defaultValue: "Bordered", comment: "Bracket highlight option: bordered")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text_editing.bracket_highlight.flash", defaultValue: "Flash", comment: "Bracket highlight option: flash")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text_editing.bracket_highlight.underline", defaultValue: "Underline", comment: "Bracket highlight option: underline")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text_editing.use_custom_color", defaultValue: "Use Custom Color", comment: "Toggle label for custom color"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text_editing.bracket_pair_highlight_color", defaultValue: "Bracket Pair Highlight Color", comment: "Label for bracket pair highlight color picker"),
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
        Toggle(String(localized: "settings.text_editing.show_gutter", defaultValue: "Show Gutter", comment: "Toggle label for gutter visibility"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text_editing.show_gutter_help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text for gutter visibility"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text_editing.show_minimap", defaultValue: "Show Minimap", comment: "Toggle label for minimap visibility"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text_editing.show_minimap_help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text for minimap visibility"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text_editing.show_code_folding_ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label for code folding ribbon"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text_editing.show_code_folding_ribbon_help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text for code folding ribbon"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text_editing.show_reformatting_guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for reformatting guide"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text_editing.show_reformatting_guide_help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text for reformatting guide"))

        Stepper(
            String(localized: "settings.text_editing.reformat_at_column", defaultValue: "Reformat at Column", comment: "Label for reformat column stepper"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text_editing.reformat_at_column_help", defaultValue: "The column at which text should be reformatted.", comment: "Help text for reformat column"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text_editing.invisibles.label", defaultValue: "Show Invisible Characters", comment: "Label for show invisible characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text_editing.invisibles.configure", defaultValue: "Configure...", comment: "Button to configure invisible characters"))
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
            Text(String(localized: "settings.text_editing.warning_chars.label", defaultValue: "Show Warning Characters", comment: "Label for show warning characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text_editing.warning_chars.configure", defaultValue: "Configure...", comment: "Button to configure warning characters"))
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
