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
        MonospacedFontPicker(title: String(localized: "text_editing.font", comment: "Font label"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            "text_editing.font_size",
            comment: "Font size label",
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
            Text("text_editing.autocomplete_braces_description", comment: "Autocomplete braces description")
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
            Toggle("text_editing.use_system_cursor", comment: "Use system cursor toggle", isOn: $textEditing.useSystemCursor)
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
                Text("text_editing.overscroll.none", comment: "Overscroll option")
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text("text_editing.overscroll.small", comment: "Overscroll option")
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text("text_editing.overscroll.medium", comment: "Overscroll option")
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text("text_editing.overscroll.large", comment: "Overscroll option")
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
                Text("text_editing.indent.tabs", comment: "Indent type")
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text("text_editing.indent.spaces", comment: "Indent type")
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        "text_editing.indent_width",
                        comment: "Indent width label",
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text("text_editing.spaces", comment: "Spaces unit")
                        .foregroundColor(.secondary)
                }
                .help("text_editing.indent_width_help", comment: "Indent width help text")
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
            Text("text_editing.spaces", comment: "Spaces unit")
                .foregroundColor(.secondary)
        }
        .help("text_editing.tab_width_help", comment: "Tab width help text")
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
                Text("text_editing.bracket_highlight.disabled", comment: "Bracket highlight option").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text("text_editing.bracket_highlight.bordered", comment: "Bracket highlight option").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text("text_editing.bracket_highlight.flash", comment: "Bracket highlight option").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text("text_editing.bracket_highlight.underline", comment: "Bracket highlight option").tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle("text_editing.use_custom_color", comment: "Use custom color toggle", isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    "text_editing.bracket_pair_highlight_color",
                    comment: "Bracket pair highlight color picker label",
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
            .help("text_editing.gutter_description", comment: "Gutter description")
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle("text_editing.show_minimap", comment: "Show minimap toggle", isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help("text_editing.minimap_description", comment: "Minimap description")
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle("text_editing.show_code_folding_ribbon", comment: "Show code folding ribbon toggle", isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help("text_editing.code_folding_ribbon_description", comment: "Code folding ribbon description")
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle("Show Reformatting Guide", isOn: $textEditing.showReformattingGuide)
            .help("text_editing.reformatting_guide_description", comment: "Reformatting guide description")

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
        .help("text_editing.reformat_column_description", comment: "Reformat column description")
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text("text_editing.show_invisible_characters", comment: "Show invisible characters label")
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text("text_editing.configure", comment: "Configure button")
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
            Text("text_editing.show_warning_characters", comment: "Show warning characters label")
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text("text_editing.configure", comment: "Configure button")
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
