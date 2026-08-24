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
        MonospacedFontPicker(title: String(localized: "settings.text_editing.view.font", defaultValue: "Font", comment: "Section title for font settings in text editing preferences"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text_editing.view.font_size", defaultValue: "Font Size", comment: "Label for font size setting in text editing preferences"),
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
            Text(String(localized: "settings.text_editing.view.autocomplete_braces", defaultValue: "Autocomplete braces", comment: "Section title for brace autocompletion settings"))
            Text("Automatically insert closing braces (\"}\")")
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text_editing.view.enable_type_over_completion", defaultValue: "Enable type-over completion", comment: "Toggle label for enabling type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text_editing.view.wrap_lines_to_editor_width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrapping lines to editor width"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text_editing.view.use_system_cursor", defaultValue: "Use System Cursor", comment: "Toggle label for using system cursor in editor"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text_editing.view.editor_overscroll", defaultValue: "Editor Overscroll", comment: "Section title for editor overscroll amount"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text_editing.view.editor_overscroll.none", defaultValue: "None", comment: "Option label for no editor overscroll"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text_editing.view.editor_overscroll.small", defaultValue: "Small", comment: "Option label for small editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text_editing.view.editor_overscroll.medium", defaultValue: "Medium", comment: "Option label for medium editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text_editing.view.editor_overscroll.large", defaultValue: "Large", comment: "Option label for large editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text_editing.view.line_height", defaultValue: "Line Height", comment: "Label for line height setting in text editing preferences"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text_editing.view.prefer_indent_using", defaultValue: "Prefer Indent Using", comment: "Label for indentation style preference"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text_editing.view.prefer_indent_using.tabs", defaultValue: "Tabs", comment: "Option label for tab-based indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text_editing.view.prefer_indent_using.spaces", defaultValue: "Spaces", comment: "Option label for space-based indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text_editing.view.indent_width", defaultValue: "Indent Width", comment: "Label for indent width setting"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text_editing.view.spaces_unit", defaultValue: "spaces", comment: "Unit label for number of spaces"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text_editing.view.indent_width.help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text describing indent width behavior"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text_editing.view.tab_width", defaultValue: "Tab Width", comment: "Label for tab width setting"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text_editing.view.tab_width.spaces_unit", defaultValue: "spaces", comment: "Unit label for tab width measured in spaces"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text_editing.view.tab_width.help", defaultValue: "The visual width of tabs.", comment: "Help text describing tab width setting"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text_editing.view.letter_spacing", defaultValue: "Letter Spacing", comment: "Label for letter spacing setting"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text_editing.view.bracket_pair_highlight", defaultValue: "Bracket Pair Highlight", comment: "Section title for bracket pair highlight settings"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text_editing.view.bracket_pair_highlight.disabled", defaultValue: "Disabled", comment: "Option label for disabled bracket pair highlight")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text_editing.view.bracket_pair_highlight.bordered", defaultValue: "Bordered", comment: "Option label for bordered bracket pair highlight style")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text_editing.view.bracket_pair_highlight.flash", defaultValue: "Flash", comment: "Option label for flashing bracket pair highlight style")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text_editing.view.bracket_pair_highlight.underline", defaultValue: "Underline", comment: "Option label for underlined bracket pair highlight style")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text_editing.view.bracket_pair_highlight.use_custom_color", defaultValue: "Use Custom Color", comment: "Toggle label for using custom bracket pair highlight color"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text_editing.view.bracket_pair_highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Label for bracket pair highlight color picker"),
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
        Toggle(String(localized: "settings.text_editing.view.show_gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing the editor gutter"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text_editing.view.show_gutter.help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text describing the editor gutter"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text_editing.view.show_minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing the minimap"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text_editing.view.show_minimap.help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text describing the minimap feature"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text_editing.view.show_code_folding_ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label for showing code folding ribbon"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text_editing.view.show_code_folding_ribbon.help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text describing code folding ribbon behavior"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text_editing.view.show_reformatting_guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text_editing.view.show_reformatting_guide.help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text describing reformatting guide"))

        Stepper(
            String(localized: "settings.text_editing.view.reformat_at_column", defaultValue: "Reformat at Column", comment: "Label for reformat column setting"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text_editing.view.reformat_at_column.help", defaultValue: "The column at which text should be reformatted.", comment: "Help text describing reformat column behavior"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text("Show Invisible Characters")
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text("Configure...")
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
            Text("Show Warning Characters")
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text("Configure...")
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
