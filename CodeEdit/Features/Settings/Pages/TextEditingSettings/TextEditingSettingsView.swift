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
        MonospacedFontPicker(title: String(localized: "font", defaultValue: "Font", comment: "Font picker label"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "swift.preflight.literal.382153", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Text(String(localized: "swift.preflight.literal.382154", defaultValue: "Autocomplete braces", comment: "Toggle for autocomplete braces"))
            Text(String(localized: "settings.text-editing.autocomplete-braces-description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description for autocomplete braces"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "swift.preflight.literal.382156", defaultValue: "Enable type-over completion", comment: "Toggle for type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "swift.preflight.literal.382157", defaultValue: "Wrap lines to editor width", comment: "Toggle for line wrapping"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text-editing.use-system-cursor", defaultValue: "Use System Cursor", comment: "Toggle for system cursor"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "swift.preflight.literal.382159", defaultValue: "Editor Overscroll", comment: "Picker for editor overscroll setting"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text-editing.overscroll.none", defaultValue: "None", comment: "Overscroll option: none"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text-editing.overscroll.small", defaultValue: "Small", comment: "Overscroll option: small"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text-editing.overscroll.medium", defaultValue: "Medium", comment: "Overscroll option: medium"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text-editing.overscroll.large", defaultValue: "Large", comment: "Overscroll option: large"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "swift.preflight.literal.382164", defaultValue: "Line Height", comment: "Line height stepper label"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "swift.preflight.literal.382165", defaultValue: "Prefer Indent Using", comment: "Picker for indent type preference"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text-editing.indent.tabs", defaultValue: "Tabs", comment: "Indent option: tabs"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text-editing.indent.spaces", defaultValue: "Spaces", comment: "Indent option: spaces"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text-editing.indent-width", defaultValue: "Indent Width", comment: "Indent width stepper label"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text-editing.spaces-unit", defaultValue: "spaces", comment: "Unit label for space count"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text-editing.indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width setting"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "swift.preflight.literal.382171", defaultValue: "Tab Width", comment: "Tab width stepper label"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "swift.preflight.literal.382172", defaultValue: "spaces", comment: "Unit label for tab width"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text-editing.tab-width-help", defaultValue: "The visual width of tabs.", comment: "Help text for tab width setting"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "swift.preflight.literal.382174", defaultValue: "Letter Spacing", comment: "Letter spacing stepper label"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "swift.preflight.literal.382175", defaultValue: "Bracket Pair Highlight", comment: "Picker for bracket pair highlight style"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text-editing.bracket-highlight.disabled", defaultValue: "Disabled", comment: "Bracket highlight option: disabled")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text-editing.bracket-highlight.bordered", defaultValue: "Bordered", comment: "Bracket highlight option: bordered")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text-editing.bracket-highlight.flash", defaultValue: "Flash", comment: "Bracket highlight option: flash")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text-editing.bracket-highlight.underline", defaultValue: "Underline", comment: "Bracket highlight option: underline")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text-editing.use-custom-color", defaultValue: "Use Custom Color", comment: "Toggle for custom bracket color"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "bracket_pair_highlight_color", defaultValue: "Bracket Pair Highlight Color", comment: "Color picker for bracket pair highlight"),
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
        Toggle(String(localized: "swift.preflight.literal.382182", defaultValue: "Show Gutter", comment: "Toggle for gutter display"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text-editing.show-gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text for show gutter setting"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "swift.preflight.literal.382184", defaultValue: "Show Minimap", comment: "Toggle for minimap display"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.show-minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text for show minimap setting"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text-editing.show-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle for code folding ribbon"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.show-folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text for show folding ribbon setting"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "swift.preflight.literal.382188", defaultValue: "Show Reformatting Guide", comment: "Toggle for reformatting guide"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text-editing.show-reformatting-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text for show reformatting guide setting"))

        Stepper(
            String(localized: "swift.preflight.literal.382190", defaultValue: "Reformat at Column", comment: "Stepper for reformat column"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text-editing.reformat-at-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Help text for reformat at column setting"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text-editing.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Label for show invisible characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.configure", defaultValue: "Configure...", comment: "Button to configure invisible characters"))
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
            Text(String(localized: "settings.text-editing.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Label for show warning characters setting"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "swift.preflight.literal.382195", defaultValue: "Configure...", comment: "Button to configure warning characters"))
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
