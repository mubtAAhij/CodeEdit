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
        MonospacedFontPicker(title: String(localized: "text-editing.font", defaultValue: "Font", comment: "Font picker label"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "text-editing.font-size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Text(String(localized: "text-editing.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Autocomplete braces toggle"))
            Text(String(localized: "text-editing.autocomplete-braces-help", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Autocomplete braces help text"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "text-editing.type-over-completion", defaultValue: "Enable type-over completion", comment: "Type-over completion toggle"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "text-editing.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Wrap lines toggle"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "text-editing.use-system-cursor", defaultValue: "Use System Cursor", comment: "Use system cursor toggle"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "text-editing.overscroll", defaultValue: "Editor Overscroll", comment: "Overscroll picker label"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "text-editing.overscroll.none", defaultValue: "None", comment: "No overscroll option"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "text-editing.overscroll.small", defaultValue: "Small", comment: "Small overscroll option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "text-editing.overscroll.medium", defaultValue: "Medium", comment: "Medium overscroll option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "text-editing.overscroll.large", defaultValue: "Large", comment: "Large overscroll option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "text-editing.line-height", defaultValue: "Line Height", comment: "Line height stepper label"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "text-editing.prefer-indent", defaultValue: "Prefer Indent Using", comment: "Indent preference picker label"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "text-editing.indent.tabs", defaultValue: "Tabs", comment: "Tabs indent option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "text-editing.indent.spaces", defaultValue: "Spaces", comment: "Spaces indent option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text-editing.indent-width", defaultValue: "Indent Width", comment: "Indent width stepper label"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "text-editing.spaces-unit", defaultValue: "spaces", comment: "Spaces unit label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text-editing.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Indent width help text"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "text-editing.tab-width", defaultValue: "Tab Width", comment: "Tab width stepper label"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "text-editing.spaces-unit", defaultValue: "spaces", comment: "Spaces unit label"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text-editing.tab-width-help", defaultValue: "The visual width of tabs.", comment: "Tab width help text"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "text-editing.letter-spacing", defaultValue: "Letter Spacing", comment: "Letter spacing stepper label"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "text-editing.bracket-highlight", defaultValue: "Bracket Pair Highlight", comment: "Bracket pair highlight picker label"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "text-editing.bracket-highlight.disabled", defaultValue: "Disabled", comment: "Disabled bracket highlight option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "text-editing.bracket-highlight.bordered", defaultValue: "Bordered", comment: "Bordered bracket highlight option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "text-editing.bracket-highlight.flash", defaultValue: "Flash", comment: "Flash bracket highlight option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "text-editing.bracket-highlight.underline", defaultValue: "Underline", comment: "Underline bracket highlight option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text-editing.bracket-custom-color", defaultValue: "Use Custom Color", comment: "Use custom color toggle"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "text-editing.bracket-color", defaultValue: "Bracket Pair Highlight Color", comment: "Bracket pair highlight color picker"),
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
        Toggle(String(localized: "text-editing.show-gutter", defaultValue: "Show Gutter", comment: "Show gutter toggle"), isOn: $textEditing.showGutter)
            .help(String(localized: "text-editing.show-gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Show gutter help text"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text-editing.show-minimap", defaultValue: "Show Minimap", comment: "Show minimap toggle"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing.show-minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Show minimap help text"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text-editing.show-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Show code folding ribbon toggle"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing.show-folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Show code folding ribbon help text"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "text-editing.show-reformat-guide", defaultValue: "Show Reformatting Guide", comment: "Show reformatting guide toggle"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text-editing.show-reformat-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Show reformatting guide help text"))

        Stepper(
            String(localized: "text-editing.reformat-column", defaultValue: "Reformat at Column", comment: "Reformat at column stepper label"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "text-editing.reformat-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Reformat at column help text"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "text-editing.show-invisible-chars", defaultValue: "Show Invisible Characters", comment: "Show invisible characters toggle label"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "text-editing.configure", defaultValue: "Configure...", comment: "Configure button label"))
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
            Text(String(localized: "text-editing.show-warning-chars", defaultValue: "Show Warning Characters", comment: "Show warning characters toggle label"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "text-editing.configure", defaultValue: "Configure...", comment: "Configure button label"))
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
