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
            String(localized: "font-size", defaultValue: "Font Size", comment: "Font size stepper label"),
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
            Text(String(localized: "autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Autocomplete braces toggle label"))
            Text(String(localized: "autocomplete-braces-description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Autocomplete braces description", os_id: "102524"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "enable-typeover", defaultValue: "Enable type-over completion", comment: "Enable type-over completion toggle label"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Wrap lines toggle label"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "use-system-cursor", defaultValue: "Use System Cursor", comment: "Use system cursor toggle label", os_id: "102525"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "editor-overscroll", defaultValue: "Editor Overscroll", comment: "Editor overscroll picker label"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "none", defaultValue: "None", comment: "None option", os_id: "102304"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "small", defaultValue: "Small", comment: "Small option", os_id: "102402"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "medium", defaultValue: "Medium", comment: "Medium option"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "large", defaultValue: "Large", comment: "Large option", os_id: "102404"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "line-height", defaultValue: "Line Height", comment: "Line height stepper label"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "prefer-indent", defaultValue: "Prefer Indent Using", comment: "Prefer indent picker label"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "tabs", defaultValue: "Tabs", comment: "Tabs option", os_id: "102043"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "spaces", defaultValue: "Spaces", comment: "Spaces option", os_id: "102042"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "indent-width", defaultValue: "Indent Width", comment: "Indent width stepper label", os_id: "102526"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "spaces-unit", defaultValue: "spaces", comment: "Spaces unit label"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "indent-width-help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Indent width help text", os_id: "102048"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "tab-width", defaultValue: "Tab Width", comment: "Tab width stepper label"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "spaces-unit", defaultValue: "spaces", comment: "Spaces unit label", os_id: "102527"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "tab-width-help", defaultValue: "The visual width of tabs.", comment: "Tab width help text", os_id: "102528"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "letter-spacing", defaultValue: "Letter Spacing", comment: "Letter spacing stepper label"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Bracket pair highlight picker label"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "disabled", defaultValue: "Disabled", comment: "Disabled option", os_id: "102529")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "bordered", defaultValue: "Bordered", comment: "Bordered option", os_id: "102530")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "flash", defaultValue: "Flash", comment: "Flash option", os_id: "102531")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "underline", defaultValue: "Underline", comment: "Underline option", os_id: "102474")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "use-custom-color", defaultValue: "Use Custom Color", comment: "Use custom color toggle label", os_id: "102532"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "bracket-pair-highlight-color", defaultValue: "Bracket Pair Highlight Color", comment: "Bracket pair highlight color picker label", os_id: "102533"),
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
        Toggle(String(localized: "show-gutter", defaultValue: "Show Gutter", comment: "Show gutter toggle label"), isOn: $textEditing.showGutter)
            .help(String(localized: "show-gutter-help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Show gutter help text", os_id: "102534"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "show-minimap", defaultValue: "Show Minimap", comment: "Show minimap toggle label"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "show-minimap-help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Show minimap help text", os_id: "102535"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "show-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Show code folding ribbon toggle label", os_id: "102536"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "show-folding-ribbon-help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Show code folding ribbon help text", os_id: "102537"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Show reformatting guide toggle label"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "show-reformatting-guide-help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Show reformatting guide help text", os_id: "102538"))

        Stepper(
            String(localized: "reformat-at-column", defaultValue: "Reformat at Column", comment: "Reformat at column stepper label"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "reformat-at-column-help", defaultValue: "The column at which text should be reformatted.", comment: "Reformat at column help text", os_id: "102539"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Show invisible characters label", os_id: "102540"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "configure", defaultValue: "Configure...", comment: "Configure button"))
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
            Text(String(localized: "show-warning-characters", defaultValue: "Show Warning Characters", comment: "Show warning characters label", os_id: "102542"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "configure", defaultValue: "Configure...", comment: "Configure button", os_id: "102541"))
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
