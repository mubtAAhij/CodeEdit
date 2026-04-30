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
        MonospacedFontPicker(title: String(localized: "settings.text-editing.font", defaultValue: "Font", comment: "Text editing font setting"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text-editing.font-size", defaultValue: "Font Size", comment: "Text editing font size setting"),
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
            Text(String(localized: "settings.text-editing.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Text editing autocomplete braces setting"))
            Text(String(localized: "settings.text-editing.autocomplete-braces-description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Text editing autocomplete braces description"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text-editing.type-over-completion", defaultValue: "Enable type-over completion", comment: "Text editing type-over completion setting"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text-editing.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Text editing wrap lines setting"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text-editing.system-cursor", defaultValue: "Use System Cursor", comment: "Text editing system cursor setting"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.overscroll", defaultValue: "Editor Overscroll", comment: "Text editing overscroll setting"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text-editing.overscroll.none", defaultValue: "None", comment: "Overscroll none option"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text-editing.overscroll.small", defaultValue: "Small", comment: "Overscroll small option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text-editing.overscroll.medium", defaultValue: "Medium", comment: "Overscroll medium option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text-editing.overscroll.large", defaultValue: "Large", comment: "Overscroll large option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text-editing.line-height", defaultValue: "Line Height", comment: "Text editing line height setting"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text-editing.indent-using", defaultValue: "Prefer Indent Using", comment: "Text editing indent using setting"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text-editing.indent-using.tabs", defaultValue: "Tabs", comment: "Indent using tabs option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text-editing.indent-using.spaces", defaultValue: "Spaces", comment: "Indent using spaces option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text-editing.indent-width", defaultValue: "Indent Width", comment: "Text editing indent width setting"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text-editing.indent-width.unit", defaultValue: "spaces", comment: "Indent width unit label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text-editing.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width setting"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text-editing.tab-width", defaultValue: "Tab Width", comment: "Text editing tab width setting"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text-editing.tab-width.unit", defaultValue: "spaces", comment: "Tab width unit label"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text-editing.tab-width-help", defaultValue: "The visual width of tabs.", comment: "Help text for tab width setting"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text-editing.letter-spacing", defaultValue: "Letter Spacing", comment: "Text editing letter spacing setting"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.bracket-highlight", defaultValue: "Bracket Pair Highlight", comment: "Text editing bracket pair highlight setting"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text-editing.bracket-highlight.disabled", defaultValue: "Disabled", comment: "Bracket highlight disabled option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text-editing.bracket-highlight.bordered", defaultValue: "Bordered", comment: "Bracket highlight bordered option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text-editing.bracket-highlight.flash", defaultValue: "Flash", comment: "Bracket highlight flash option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text-editing.bracket-highlight.underline", defaultValue: "Underline", comment: "Bracket highlight underline option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text-editing.bracket-highlight.custom-color", defaultValue: "Use Custom Color", comment: "Use custom color for bracket highlight"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text-editing.bracket-highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Bracket pair highlight color setting"),
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
        Toggle(String(localized: "settings.text-editing.show-gutter", defaultValue: "Show Gutter", comment: "Text editing show gutter setting"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text-editing.show-gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text for show gutter setting"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text-editing.show-minimap", defaultValue: "Show Minimap", comment: "Text editing show minimap setting"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.show-minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text for show minimap setting"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text-editing.show-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Text editing show code folding ribbon setting"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.show-folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text for show folding ribbon setting"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text-editing.show-reformat-guide", defaultValue: "Show Reformatting Guide", comment: "Text editing show reformatting guide setting"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text-editing.show-reformat-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text for show reformatting guide setting"))

        Stepper(
            String(localized: "settings.text-editing.reformat-column", defaultValue: "Reformat at Column", comment: "Text editing reformat at column setting"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text-editing.reformat-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Help text for reformat column setting"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text-editing.show-invisibles", defaultValue: "Show Invisible Characters", comment: "Text editing show invisible characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.configure", defaultValue: "Configure...", comment: "Configure button for settings"))
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
            Text(String(localized: "settings.text-editing.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Text editing show warning characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.configure", defaultValue: "Configure...", comment: "Configure button for settings"))
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
