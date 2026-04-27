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
            String(localized: "text-editing.stepper.font-size", defaultValue: "Font Size", comment: "Stepper label for font size"),
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
            Text(String(localized: "text-editing.toggle.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Toggle label for autocomplete braces"))
            Text(String(localized: "text-editing.toggle.autocomplete-braces.description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description for autocomplete braces toggle"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "text-editing.toggle.type-over-completion", defaultValue: "Enable type-over completion", comment: "Toggle label for type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "text-editing.toggle.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrap lines to editor width"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "text-editing.toggle.system-cursor", defaultValue: "Use System Cursor", comment: "Toggle label for using system cursor"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "text-editing.picker.overscroll", defaultValue: "Editor Overscroll", comment: "Picker label for editor overscroll"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "text-editing.overscroll.none", defaultValue: "None", comment: "Overscroll option for none"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "text-editing.overscroll.small", defaultValue: "Small", comment: "Overscroll option for small"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "text-editing.overscroll.medium", defaultValue: "Medium", comment: "Overscroll option for medium"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "text-editing.overscroll.large", defaultValue: "Large", comment: "Overscroll option for large"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "text-editing.stepper.line-height", defaultValue: "Line Height", comment: "Stepper label for line height"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "text-editing.picker.prefer-indent", defaultValue: "Prefer Indent Using", comment: "Picker label for prefer indent using"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "text-editing.indent.tabs", defaultValue: "Tabs", comment: "Indent option for tabs"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "text-editing.indent.spaces", defaultValue: "Spaces", comment: "Indent option for spaces"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "text-editing.stepper.indent-width", defaultValue: "Indent Width", comment: "Stepper label for indent width"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "text-editing.label.spaces", defaultValue: "spaces", comment: "Label for spaces unit"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "text-editing.help.indent-width", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text for indent width"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "text-editing.stepper.tab-width", defaultValue: "Tab Width", comment: "Stepper label for tab width"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "text-editing.label.spaces", defaultValue: "spaces", comment: "Label for spaces unit"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "text-editing.help.tab-width", defaultValue: "The visual width of tabs.", comment: "Help text for tab width"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "text-editing.stepper.letter-spacing", defaultValue: "Letter Spacing", comment: "Stepper label for letter spacing"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "text-editing.picker.bracket-highlight", defaultValue: "Bracket Pair Highlight", comment: "Picker label for bracket pair highlight"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "text-editing.bracket-highlight.disabled", defaultValue: "Disabled", comment: "Bracket highlight option for disabled")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "text-editing.bracket-highlight.bordered", defaultValue: "Bordered", comment: "Bracket highlight option for bordered")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "text-editing.bracket-highlight.flash", defaultValue: "Flash", comment: "Bracket highlight option for flash")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "text-editing.bracket-highlight.underline", defaultValue: "Underline", comment: "Bracket highlight option for underline")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "text-editing.toggle.custom-color", defaultValue: "Use Custom Color", comment: "Toggle for using custom color"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    "Bracket Pair Highlight Color",
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
        Toggle(String(localized: "text-editing.toggle.show-gutter", defaultValue: "Show Gutter", comment: "Toggle for showing gutter"), isOn: $textEditing.showGutter)
            .help(String(localized: "text-editing.help.show-gutter", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text for show gutter toggle"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "text-editing.toggle.show-minimap", defaultValue: "Show Minimap", comment: "Toggle for showing minimap"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing.help.show-minimap", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text for show minimap toggle"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "text-editing.toggle.show-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle for showing code folding ribbon"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "text-editing.help.show-folding-ribbon", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text for show folding ribbon toggle"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "text-editing.toggle.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle for showing reformatting guide"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "text-editing.help.show-reformatting-guide", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text for show reformatting guide toggle"))

        Stepper(
            String(localized: "text-editing.stepper.reformat-column", defaultValue: "Reformat at Column", comment: "Stepper label for reformat at column"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "text-editing.help.reformat-column", defaultValue: "The column at which text should be reformatted.", comment: "Help text for reformat at column stepper"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "text-editing.label.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Label for show invisible characters"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "text-editing.button.configure", defaultValue: "Configure...", comment: "Button label for configure"))
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
            Text(String(localized: "text-editing.label.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Label for show warning characters"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "text-editing.button.configure", defaultValue: "Configure...", comment: "Button label for configure"))
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
