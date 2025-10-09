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
        MonospacedFontPicker(title: String(localized: "text_editing.font", comment: "Font selection label"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "text_editing.font_size", comment: "Font size label"),
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
            Text("Automatically insert closing braces (\"}\")")
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
            Toggle(String(localized: "text_editing.use_system_cursor", comment: "Use system cursor option"), isOn: $textEditing.useSystemCursor)
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
                Text(String(localized: "text_editing.cursor_blink.none", comment: "No cursor blinking option"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "text_editing.cursor_blink.small", comment: "Small cursor blinking option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "text_editing.cursor_blink.medium", comment: "Medium cursor blinking option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "text_editing.cursor_blink.large", comment: "Large cursor blinking option"))
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
                Text(String(localized: "text_editing.indentation.tabs", comment: "Tabs indentation option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "text_editing.indentation.spaces", comment: "Spaces indentation option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text_editing.indent_width", comment: "Indent width label"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "text_editing.spaces_unit", comment: "Spaces unit label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text_editing.indent_width.help", comment: "Help text for indent width setting"))
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
            Text("spaces")
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text_editing.tab_width.help", comment: "Help text for tab width setting"))
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
                Text(String(localized: "text_editing.bracket_highlight.disabled", comment: "Disabled bracket highlighting option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "text_editing.bracket_highlight.bordered", comment: "Bordered bracket highlighting option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "text_editing.bracket_highlight.flash", comment: "Flash bracket highlighting option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "text_editing.bracket_highlight.underline", comment: "Underline bracket highlighting option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text_editing.use_custom_color", comment: "Use custom color option"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "text_editing.bracket_pair_highlight_color", comment: "Label for bracket pair highlight color setting"),
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
            .help(String(localized: "text_editing.gutter_description", comment: "Description of what the gutter displays"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text_editing.show_minimap", comment: "Label for show minimap setting"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text_editing.minimap_description", comment: "Description of what the minimap provides"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text_editing.show_code_folding_ribbon", comment: "Label for show code folding ribbon setting"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text_editing.code_folding_ribbon_description", comment: "Description of what the code folding ribbon does"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle("Show Reformatting Guide", isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text_editing.reformat_guide_description", comment: "Description of the reformat column guide"))

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
        .help(String(localized: "text_editing.reformat_column_description", comment: "Description of the reformat column setting"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "text_editing.show_invisible_characters", comment: "Label for show invisible characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "text_editing.configure_button", comment: "Button label to configure settings"))
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
            Text(String(localized: "text_editing.show_warning_characters", comment: "Label for show warning characters setting"))
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
