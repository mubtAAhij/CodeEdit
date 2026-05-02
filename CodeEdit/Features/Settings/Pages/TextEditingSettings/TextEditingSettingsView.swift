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
        MonospacedFontPicker(title: String(localized: "text-editing-settings.font", defaultValue: "Font", comment: "Label for font picker"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "text-editing-settings.font-size", defaultValue: "Font Size", comment: "Label for font size stepper"),
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
            Text(String(localized: "text-editing-settings.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Label for autocomplete braces toggle"))
            Text(String(localized: "text-editing-settings.autocomplete-braces-description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description for autocomplete braces toggle"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "text-editing-settings.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Label for enable type-over completion toggle"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "text-editing-settings.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Label for wrap lines toggle"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "text-editing-settings.use-system-cursor", defaultValue: "Use System Cursor", comment: "Label for use system cursor toggle"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "text-editing-settings.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Label for editor overscroll picker"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "text-editing-settings.overscroll.none", defaultValue: "None", comment: "Option for no overscroll"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "text-editing-settings.overscroll.small", defaultValue: "Small", comment: "Option for small overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "text-editing-settings.overscroll.medium", defaultValue: "Medium", comment: "Option for medium overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "text-editing-settings.overscroll.large", defaultValue: "Large", comment: "Option for large overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "text-editing-settings.line-height", defaultValue: "Line Height", comment: "Label for line height stepper"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "text-editing-settings.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Label for prefer indent using picker"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "text-editing-settings.indent.tabs", defaultValue: "Tabs", comment: "Option for tabs indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "text-editing-settings.indent.spaces", defaultValue: "Spaces", comment: "Option for spaces indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text-editing-settings.indent-width", defaultValue: "Indent Width", comment: "Label for indent width stepper"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "text-editing-settings.spaces-unit", defaultValue: "spaces", comment: "Unit label for spaces"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text-editing-settings.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width setting"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "text-editing-settings.tab-width", defaultValue: "Tab Width", comment: "Label for tab width stepper"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "text-editing-settings.spaces-unit", defaultValue: "spaces", comment: "Unit label for spaces"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text-editing-settings.tab-width-help", defaultValue: "The visual width of tabs.", comment: "Help text for tab width setting"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "text-editing-settings.letter-spacing", defaultValue: "Letter Spacing", comment: "Label for letter spacing stepper"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "text-editing-settings.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Label for bracket pair highlight picker"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "text-editing-settings.bracket-highlight.disabled", defaultValue: "Disabled", comment: "Option for disabled bracket highlight")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "text-editing-settings.bracket-highlight.bordered", defaultValue: "Bordered", comment: "Option for bordered bracket highlight")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "text-editing-settings.bracket-highlight.flash", defaultValue: "Flash", comment: "Option for flash bracket highlight")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "text-editing-settings.bracket-highlight.underline", defaultValue: "Underline", comment: "Option for underline bracket highlight")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text-editing-settings.use-custom-color", defaultValue: "Use Custom Color", comment: "Label for use custom color toggle"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "text-editing-settings.bracket-pair-highlight-color", defaultValue: "Bracket Pair Highlight Color", comment: "Label for bracket pair highlight color picker"),
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
        Toggle(String(localized: "text-editing-settings.show-gutter", defaultValue: "Show Gutter", comment: "Label for show gutter toggle"), isOn: $textEditing.showGutter)
            .help(String(localized: "text-editing-settings.show-gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text for show gutter toggle"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text-editing-settings.show-minimap", defaultValue: "Show Minimap", comment: "Label for show minimap toggle"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing-settings.show-minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text for show minimap toggle"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text-editing-settings.show-code-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Label for show code folding ribbon toggle"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing-settings.show-code-folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text for show code folding ribbon toggle"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "text-editing-settings.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Label for show reformatting guide toggle"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text-editing-settings.show-reformatting-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text for show reformatting guide toggle"))

        Stepper(
            String(localized: "text-editing-settings.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for reformat at column stepper"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "text-editing-settings.reformat-at-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Help text for reformat at column stepper"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "text-editing-settings.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Label for show invisible characters option"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "text-editing-settings.configure", defaultValue: "Configure...", comment: "Configure button text"))
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
            Text(String(localized: "text-editing-settings.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Label for show warning characters option"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "text-editing-settings.configure", defaultValue: "Configure...", comment: "Configure button text"))
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
