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
        MonospacedFontPicker(title: String(localized: "text_editing.font", defaultValue: "Font", comment: "Label text"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "text_editing.font_size", defaultValue: "Font Size", comment: "Label text"),
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
            Text("Autocomplete braces")
            Text("text_editing.autocomplete_braces_description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description text")
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle("Enable type-over completion", isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle("Wrap lines to editor width", isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "text_editing.use_system_cursor", defaultValue: "Use System Cursor", comment: "Toggle label"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                "Editor Overscroll",
                selection: $textEditing.overscroll
            ) {
                Text("text_editing.overscroll.none", defaultValue: "None", comment: "Option text")
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text("text_editing.overscroll.small", defaultValue: "Small", comment: "Option text")
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text("text_editing.overscroll.medium", defaultValue: "Medium", comment: "Option text")
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text("text_editing.overscroll.large", defaultValue: "Large", comment: "Option text")
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            "Line Height",
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker("Prefer Indent Using", selection: $textEditing.indentOption.indentType) {
                Text("text_editing.indent.tabs", defaultValue: "Tabs", comment: "Option text")
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text("text_editing.indent.spaces", defaultValue: "Spaces", comment: "Option text")
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text_editing.indent_width", defaultValue: "Indent Width", comment: "Label text"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text("text_editing.spaces", defaultValue: "spaces", comment: "Unit label")
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text_editing.indent_width_help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                "Tab Width",
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text("text_editing.spaces", defaultValue: "spaces", comment: "Unit label")
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text_editing.tab_width_help", defaultValue: "The visual width of tabs.", comment: "Help text"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            "Letter Spacing",
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                "Bracket Pair Highlight",
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text("text_editing.bracket_highlight.disabled", defaultValue: "Disabled", comment: "Option text").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text("text_editing.bracket_highlight.bordered", defaultValue: "Bordered", comment: "Option text").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text("text_editing.bracket_highlight.flash", defaultValue: "Flash", comment: "Option text").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text("text_editing.bracket_highlight.underline", defaultValue: "Underline", comment: "Option text").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text_editing.use_custom_color", defaultValue: "Use Custom Color", comment: "Toggle label"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "text_editing.bracket_pair_highlight_color", defaultValue: "Bracket Pair Highlight Color", comment: "Label text"),
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
        Toggle("Show Gutter", isOn: $textEditing.showGutter)
            .help(String(localized: "text_editing.gutter_help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text_editing.show_minimap", defaultValue: "Show Minimap", comment: "Toggle label"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text_editing.minimap_help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text_editing.show_code_folding_ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text_editing.code_folding_ribbon_help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle("Show Reformatting Guide", isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text_editing.reformatting_guide_help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text"))

        Stepper(
            "Reformat at Column",
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "text_editing.reformat_column_help", defaultValue: "The column at which text should be reformatted.", comment: "Help text"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text("text_editing.show_invisible_characters", defaultValue: "Show Invisible Characters", comment: "Label text")
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text("text_editing.configure", defaultValue: "Configure...", comment: "Button text")
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
            Text("text_editing.show_warning_characters", defaultValue: "Show Warning Characters", comment: "Label text")
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text("text_editing.configure", defaultValue: "Configure...", comment: "Button text")
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
