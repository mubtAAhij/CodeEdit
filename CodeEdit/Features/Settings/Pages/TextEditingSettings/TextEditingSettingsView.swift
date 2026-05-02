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
        MonospacedFontPicker(title: String(localized: "settings.text.editing.view.font", defaultValue: "Font", comment: "Font picker label"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text.editing.view.font.size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Text(String(localized: "settings.text.editing.view.autocomplete.braces", defaultValue: "Autocomplete braces", comment: "Autocomplete braces toggle label"))
            Text(String(localized: "settings.text.editing.view.autocomplete.braces.description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Autocomplete braces toggle description"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text.editing.view.enable.typeover.completion", defaultValue: "Enable type-over completion", comment: "Enable type-over completion toggle label"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text.editing.view.wrap.lines", defaultValue: "Wrap lines to editor width", comment: "Wrap lines to editor width toggle label"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text.editing.view.use.system.cursor", defaultValue: "Use System Cursor", comment: "Use system cursor toggle label"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text.editing.view.editor.overscroll", defaultValue: "Editor Overscroll", comment: "Editor overscroll picker label"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text.editing.view.overscroll.none", defaultValue: "None", comment: "Overscroll option none"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text.editing.view.overscroll.small", defaultValue: "Small", comment: "Overscroll option small"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text.editing.view.overscroll.medium", defaultValue: "Medium", comment: "Overscroll option medium"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text.editing.view.overscroll.large", defaultValue: "Large", comment: "Overscroll option large"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text.editing.view.line.height", defaultValue: "Line Height", comment: "Line height stepper label"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text.editing.view.prefer.indent.using", defaultValue: "Prefer Indent Using", comment: "Prefer indent using picker label"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text.editing.view.indent.tabs", defaultValue: "Tabs", comment: "Indent option tabs"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text.editing.view.indent.spaces", defaultValue: "Spaces", comment: "Indent option spaces"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text.editing.view.indent.width", defaultValue: "Indent Width", comment: "Indent width stepper label"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text.editing.view.spaces.unit", defaultValue: "spaces", comment: "Spaces unit label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text.editing.view.indent.width.help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Indent width help text"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text.editing.view.tab.width", defaultValue: "Tab Width", comment: "Tab width stepper label"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text.editing.view.spaces.unit", defaultValue: "spaces", comment: "Spaces unit label"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text.editing.view.tab.width.help", defaultValue: "The visual width of tabs.", comment: "Tab width help text"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text.editing.view.letter.spacing", defaultValue: "Letter Spacing", comment: "Letter spacing stepper label"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text.editing.view.bracket.pair.highlight", defaultValue: "Bracket Pair Highlight", comment: "Bracket pair highlight picker label"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text.editing.view.bracket.highlight.disabled", defaultValue: "Disabled", comment: "Bracket highlight option disabled")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text.editing.view.bracket.highlight.bordered", defaultValue: "Bordered", comment: "Bracket highlight option bordered")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text.editing.view.bracket.highlight.flash", defaultValue: "Flash", comment: "Bracket highlight option flash")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text.editing.view.bracket.highlight.underline", defaultValue: "Underline", comment: "Bracket highlight option underline")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text.editing.view.use.custom.color", defaultValue: "Use Custom Color", comment: "Use custom color toggle label"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text.editing.view.bracket.pair.highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Bracket pair highlight color picker label"),
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
        Toggle(String(localized: "settings.text.editing.view.show.gutter", defaultValue: "Show Gutter", comment: "Show gutter toggle label"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text.editing.view.show.gutter.help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Show gutter help text"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text.editing.view.show.minimap", defaultValue: "Show Minimap", comment: "Show minimap toggle label"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text.editing.view.show.minimap.help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Show minimap help text"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text.editing.view.show.code.folding.ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Show code folding ribbon toggle label"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text.editing.view.show.code.folding.ribbon.help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Show code folding ribbon help text"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text.editing.view.show.reformatting.guide", defaultValue: "Show Reformatting Guide", comment: "Show reformatting guide toggle label"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text.editing.view.show.reformatting.guide.help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Show reformatting guide help text"))

        Stepper(
            String(localized: "settings.text.editing.view.reformat.at.column", defaultValue: "Reformat at Column", comment: "Reformat at column stepper label"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text.editing.view.reformat.at.column.help", defaultValue: "The column at which text should be reformatted.", comment: "Reformat at column help text"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text.editing.invisible.characters.show", defaultValue: "Show Invisible Characters", comment: "Label for show invisible characters option"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text.editing.invisible.characters.configure", defaultValue: "Configure...", comment: "Button to configure invisible characters"))
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
            Text(String(localized: "settings.text.editing.warning.characters.show", defaultValue: "Show Warning Characters", comment: "Label for show warning characters option"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text.editing.warning.characters.configure", defaultValue: "Configure...", comment: "Button to configure warning characters"))
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
