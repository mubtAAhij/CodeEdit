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
        MonospacedFontPicker(title: String(localized: "settings.text-editing.view.font", defaultValue: "Font", comment: "Text editing settings view label for font selection"), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text-editing.view.font-size", defaultValue: "Font Size", comment: "Text editing settings view label for font size"),
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
            Text(String(localized: "settings.text-editing.view.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Text editing settings view toggle label for autocompleting braces"))
            Text(String(localized: "settings.text-editing.view.autocomplete-braces.description", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Description for autocomplete braces setting"))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text-editing.view.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Text editing settings view toggle label for type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text-editing.view.wrap-lines-to-editor-width", defaultValue: "Wrap lines to editor width", comment: "Text editing settings view toggle label for line wrapping"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text-editing.view.use-system-cursor", defaultValue: "Use System Cursor", comment: "Text editing settings view toggle label for using system cursor"), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.view.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Text editing settings view label for editor overscroll amount"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text-editing.view.editor-overscroll.none", defaultValue: "None", comment: "Editor overscroll option for none"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text-editing.view.editor-overscroll.small", defaultValue: "Small", comment: "Editor overscroll option for small amount"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.medium", defaultValue: "Medium", comment: "Editor overscroll option for medium amount"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.large", defaultValue: "Large", comment: "Editor overscroll option for large amount"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text-editing.view.line-height", defaultValue: "Line Height", comment: "Text editing settings view label for line height"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text-editing.view.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Text editing settings view label for preferred indentation method"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.tabs", defaultValue: "Tabs", comment: "Indentation option for tabs"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.spaces", defaultValue: "Spaces", comment: "Indentation option for spaces"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text-editing.view.indent-width", defaultValue: "Indent Width", comment: "Text editing settings view label for indent width"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text-editing.view.indent-width.unit-spaces", defaultValue: "spaces", comment: "Unit label for indent width value"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text-editing.view.indent-width.description", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Description for indent width setting"))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text-editing.view.tab-width", defaultValue: "Tab Width", comment: "Text editing settings view label for tab width"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text-editing.view.tab-width.unit-spaces", defaultValue: "spaces", comment: "Unit label for tab width value in spaces"))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text-editing.view.tab-width.description", defaultValue: "The visual width of tabs.", comment: "Description for tab width setting"))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text-editing.view.letter-spacing", defaultValue: "Letter Spacing", comment: "Text editing settings view label for letter spacing"),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.view.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Text editing settings view label for bracket pair highlight mode"),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.disabled", defaultValue: "Disabled", comment: "Bracket pair highlight option disabled")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.bordered", defaultValue: "Bordered", comment: "Bracket pair highlight option bordered")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.flash", defaultValue: "Flash", comment: "Bracket pair highlight option flash")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.underline", defaultValue: "Underline", comment: "Bracket pair highlight option underline")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text-editing.view.bracket-pair-highlight.use-custom-color", defaultValue: "Use Custom Color", comment: "Toggle label for using custom bracket pair highlight color"), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text-editing.view.bracket-pair-highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Color picker label for bracket pair highlight color"),
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
        Toggle(String(localized: "settings.text-editing.view.show-gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing gutter"), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text-editing.view.show-gutter.description", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Description for gutter visibility setting"))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text-editing.view.show-minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing minimap"), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.view.show-minimap.description", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Description for minimap visibility setting"))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text-editing.view.show-code-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label for showing code folding ribbon"), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.view.show-code-folding-ribbon.description", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Description for code folding ribbon setting"))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text-editing.view.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide"), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text-editing.view.show-reformatting-guide.description", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Description for reformatting guide setting"))

        Stepper(
            String(localized: "settings.text-editing.view.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for reformat at column value"),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text-editing.view.reformat-at-column.description", defaultValue: "The column at which text should be reformatted.", comment: "Description for reformat at column setting"))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text-editing.invisible-characters.show", defaultValue: "Show Invisible Characters", comment: "Toggle title for showing invisible characters in editor"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.invisible-characters.configure", defaultValue: "Configure...", comment: "Button title to configure invisible character options"))
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
            Text(String(localized: "settings.text-editing.warning-characters.show", defaultValue: "Show Warning Characters", comment: "Toggle title for showing warning characters in editor"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.warning-characters.configure", defaultValue: "Configure...", comment: "Button title to configure warning character options"))
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
