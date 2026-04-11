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
        MonospacedFontPicker(title: "Font", selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "text-editing-settings.font-size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Text(String(localized: "text-editing-settings.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Autocomplete braces toggle label"))
            Text(String(localized: "text-editing-settings.autocomplete-braces-description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Autocomplete braces description"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "text-editing-settings.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Enable type-over completion toggle label"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "text-editing-settings.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Wrap lines toggle label"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "text-editing-settings.use-system-cursor", defaultValue: "Use System Cursor", comment: "Use system cursor toggle label"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "text-editing-settings.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Editor overscroll picker label"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "text-editing-settings.none", defaultValue: "None", comment: "None option"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "text-editing-settings.small", defaultValue: "Small", comment: "Small option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "text-editing-settings.medium", defaultValue: "Medium", comment: "Medium option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "text-editing-settings.large", defaultValue: "Large", comment: "Large option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "text-editing-settings.line-height", defaultValue: "Line Height", comment: "Line height stepper label"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "text-editing-settings.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Prefer indent using picker label"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "text-editing-settings.tabs", defaultValue: "Tabs", comment: "Tabs option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "text-editing-settings.spaces", defaultValue: "Spaces", comment: "Spaces option"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text-editing-settings.indent-width", defaultValue: "Indent Width", comment: "Indent width stepper label"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "text-editing-settings.spaces-label", defaultValue: "spaces", comment: "Spaces label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text-editing-settings.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Indent width help text"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "text-editing-settings.tab-width", defaultValue: "Tab Width", comment: "Tab width stepper label"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "text-editing-settings.spaces-label-tab", defaultValue: "spaces", comment: "Spaces label for tab width"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text-editing-settings.tab-width-help", defaultValue: "The visual width of tabs.", comment: "Tab width help text"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "text-editing-settings.letter-spacing", defaultValue: "Letter Spacing", comment: "Letter spacing stepper label"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "text-editing-settings.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Bracket pair highlight picker label"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "text-editing-settings.disabled", defaultValue: "Disabled", comment: "Disabled option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "text-editing-settings.bordered", defaultValue: "Bordered", comment: "Bordered option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "text-editing-settings.flash", defaultValue: "Flash", comment: "Flash option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "text-editing-settings.underline", defaultValue: "Underline", comment: "Underline option")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text-editing-settings.use-custom-color", defaultValue: "Use Custom Color", comment: "Use custom color toggle label"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "text-editing-settings.bracket-pair-highlight-color", defaultValue: "Bracket Pair Highlight Color", comment: "Bracket pair highlight color label"),
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
        Toggle(String(localized: "text-editing-settings.show-gutter", defaultValue: "Show Gutter", comment: "Show gutter toggle label"), isOn: $textEditing.showGutter)
            .help(String(localized: "text-editing-settings.gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Gutter help text"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text-editing-settings.show-minimap", defaultValue: "Show Minimap", comment: "Show minimap toggle label"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing-settings.minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Minimap help text"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text-editing-settings.show-code-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Show code folding ribbon toggle label"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing-settings.folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Folding ribbon help text"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "text-editing-settings.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Show reformatting guide toggle label"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text-editing-settings.reformatting-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Reformatting guide help text"))

        Stepper(
            String(localized: "text-editing-settings.reformat-at-column", defaultValue: "Reformat at Column", comment: "Reformat at column stepper label"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "text-editing-settings.reformat-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Reformat column help text"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "text-editing-settings.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Show invisible characters label"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "text-editing-settings.configure", defaultValue: "Configure...", comment: "Configure button"))
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
            Text(String(localized: "text-editing-settings.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Show warning characters label"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "text-editing-settings.configure-warning", defaultValue: "Configure...", comment: "Configure warning characters button"))
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
