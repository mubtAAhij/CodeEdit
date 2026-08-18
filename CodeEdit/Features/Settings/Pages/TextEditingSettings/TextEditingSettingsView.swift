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
        MonospacedFontPicker(title: String(localized: "settings.text-editing.view.font", defaultValue: "Font", comment: "Section row title for font setting in text editing settings view."), selectedFontName: $textEditing.font.name)
    }

    @ViewBuilder private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text-editing.view.font-size", defaultValue: "Font Size", comment: "Section row title for font size setting in text editing settings view."),
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
            Text(String(localized: "settings.text-editing.view.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Toggle label for autocomplete braces in text editing settings view."))
            Text(String(localized: "settings.text-editing.view.autocomplete-braces.help", defaultValue: "Automatically insert closing braces (\"}\")", comment: "Help text describing autocomplete braces behavior."))
        }
    }

    @ViewBuilder private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text-editing.view.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Toggle label for type-over completion behavior."), isOn: $textEditing.enableTypeOverCompletion)
    }

    @ViewBuilder private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text-editing.view.wrap-lines-to-editor-width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrapping lines to editor width."), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text-editing.view.use-system-cursor", defaultValue: "Use System Cursor", comment: "Toggle label for using system cursor in editor."), isOn: $textEditing.useSystemCursor)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.view.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Section title for editor overscroll setting."),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text-editing.view.editor-overscroll.none", defaultValue: "None", comment: "Option label for no overscroll in editor."))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text-editing.view.editor-overscroll.small", defaultValue: "Small", comment: "Option label for small overscroll in editor."))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.medium", defaultValue: "Medium", comment: "Option label for medium overscroll in editor."))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.large", defaultValue: "Large", comment: "Option label for large overscroll in editor."))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    @ViewBuilder private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text-editing.view.line-height", defaultValue: "Line Height", comment: "Section row title for line height setting."),
            value: $textEditing.lineHeightMultiple,
            in: 0.75...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text-editing.view.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Section title for preferred indentation type."), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.tabs", defaultValue: "Tabs", comment: "Option label for tabs indentation."))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.spaces", defaultValue: "Spaces", comment: "Option label for spaces indentation."))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text-editing.view.indent-width", defaultValue: "Indent Width", comment: "Section title for indent width setting."),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0...10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text-editing.view.indent-width.spaces-suffix", defaultValue: "spaces", comment: "Unit label for indent width value in spaces."))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text-editing.view.indent-width.help", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Help text describing indent width setting."))
            }
        }
    }

    @ViewBuilder private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text-editing.view.tab-width", defaultValue: "Tab Width", comment: "Section title for tab width setting."),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1...16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text-editing.view.tab-width.spaces-suffix", defaultValue: "spaces", comment: "Unit label suffix for tab width value in spaces."))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text-editing.view.tab-width.help", defaultValue: "The visual width of tabs.", comment: "Help text describing tab width setting."))
    }

    @ViewBuilder private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text-editing.view.letter-spacing", defaultValue: "Letter Spacing", comment: "Section row title for letter spacing setting."),
            value: $textEditing.letterSpacing,
            in: 0.5...2.0,
            step: 0.05,
            format: .number
        )
    }

    @ViewBuilder private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.view.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Section title for bracket pair highlight settings."),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.disabled", defaultValue: "Disabled", comment: "Option label for disabling bracket pair highlight.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.bordered", defaultValue: "Bordered", comment: "Option label for bordered bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.flash", defaultValue: "Flash", comment: "Option label for flash bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text-editing.view.bracket-pair-highlight.underline", defaultValue: "Underline", comment: "Option label for underline bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text-editing.view.bracket-pair-highlight.use-custom-color", defaultValue: "Use Custom Color", comment: "Toggle label for using a custom bracket pair highlight color."), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text-editing.view.bracket-pair-highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Label for bracket pair highlight color picker."),
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
        Toggle(String(localized: "settings.text-editing.view.show-gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing editor gutter."), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text-editing.view.show-gutter.help", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Help text describing the editor gutter."))
    }

    @ViewBuilder private var showMinimap: some View {
        Toggle(String(localized: "settings.text-editing.view.show-minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing minimap."), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.view.show-minimap.help", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Help text describing the minimap feature."))
    }

    @ViewBuilder private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text-editing.view.show-code-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label for showing code folding ribbon."), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.view.show-code-folding-ribbon.help", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Help text describing the code folding ribbon behavior."))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text-editing.view.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide."), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text-editing.view.show-reformatting-guide.help", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Help text describing the reformatting guide."))

        Stepper(
            String(localized: "settings.text-editing.view.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for reformat at column setting."),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40...200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text-editing.view.reformat-at-column.help", defaultValue: "The column at which text should be reformatted.", comment: "Help text describing reformat at column setting."))
    }

    @ViewBuilder private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text-editing.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Text editing settings toggle label for showing invisible characters"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.invisible-characters.configure", defaultValue: "Configure...", comment: "Button title to configure invisible characters settings"))
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
            Text(String(localized: "settings.text-editing.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Text editing settings toggle label for showing warning characters"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.warning-characters.configure", defaultValue: "Configure...", comment: "Button title to configure warning characters settings"))
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
