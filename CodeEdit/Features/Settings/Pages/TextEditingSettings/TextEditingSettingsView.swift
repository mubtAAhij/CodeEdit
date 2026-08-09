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
    private var fontSelector: some View {
        MonospacedFontPicker(title: String(localized: "settings.text-editing.view.font", defaultValue: "Font", comment: "Section label for editor font settings"), selectedFontName: $textEditing.font.name)
    }

    private var fontSizeSelector: some View {
        Stepper(
            String(localized: "settings.text-editing.view.font-size", defaultValue: "Font Size", comment: "Label for editor font size control"),
            value: $textEditing.font.size,
            in: 1 ... 288,
            step: 1,
            format: .number
        )
    }

    private var fontWeightSelector: some View {
        FontWeightPicker(selection: $textEditing.font.weight)
    }

    private var autocompleteBraces: some View {
        Toggle(isOn: $textEditing.autocompleteBraces) {
            Text(String(localized: "settings.text-editing.view.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Section label for autocomplete braces option"))
            Text("Automatically insert closing braces (\"}\")")
        }
    }

    private var enableTypeOverCompletion: some View {
        Toggle(String(localized: "settings.text-editing.view.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Toggle label for enabling type-over completion"), isOn: $textEditing.enableTypeOverCompletion)
    }

    private var wrapLinesToEditorWidth: some View {
        Toggle(String(localized: "settings.text-editing.view.wrap-lines-to-editor-width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrapping lines to editor width"), isOn: $textEditing.wrapLinesToEditorWidth)
    }

    @ViewBuilder private var useSystemCursor: some View {
        if #available(macOS 14, *) {
            Toggle(String(localized: "settings.text-editing.view.use-system-cursor", defaultValue: "Use System Cursor", comment: "Toggle label for using system cursor in editor"), isOn: $textEditing.useSystemCursor)
        }
    }

    private var overscroll: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.view.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Section label for editor overscroll amount setting"),
                selection: $textEditing.overscroll
            ) {
                Text(String(localized: "settings.text-editing.view.editor-overscroll.none", defaultValue: "None", comment: "Option label for no editor overscroll"))
                    .tag(SettingsData.TextEditingSettings.OverscrollOption.none)
                Divider()
                Text(String(localized: "settings.text-editing.view.editor-overscroll.small", defaultValue: "Small", comment: "Option label for small editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.small
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.medium", defaultValue: "Medium", comment: "Option label for medium editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.medium
                    )
                Text(String(localized: "settings.text-editing.view.editor-overscroll.large", defaultValue: "Large", comment: "Option label for large editor overscroll"))
                    .tag(
                        SettingsData.TextEditingSettings.OverscrollOption.large
                    )
            }
        }
    }

    private var lineHeight: some View {
        Stepper(
            String(localized: "settings.text-editing.view.line-height", defaultValue: "Line Height", comment: "Section label for line height setting"),
            value: $textEditing.lineHeightMultiple,
            in: 0.75 ... 2.0,
            step: 0.05,
            format: .number
        )
    }

    private var indentOption: some View {
        Group {
            Picker(String(localized: "settings.text-editing.view.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Section label for preferred indentation mode"), selection: $textEditing.indentOption.indentType) {
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.tabs", defaultValue: "Tabs", comment: "Option label for using tabs for indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.tab)
                Text(String(localized: "settings.text-editing.view.prefer-indent-using.spaces", defaultValue: "Spaces", comment: "Option label for using spaces for indentation"))
                    .tag(SettingsData.TextEditingSettings.IndentOption.IndentType.spaces)
            }
            if textEditing.indentOption.indentType == .spaces {
                HStack {
                    Stepper(
                        String(localized: "settings.text-editing.view.indent-width", defaultValue: "Indent Width", comment: "Label for indent width setting"),
                        value: Binding<Double>(
                            get: { Double(textEditing.indentOption.spaceCount) },
                            set: { textEditing.indentOption.spaceCount = Int($0) }
                        ),
                        in: 0 ... 10,
                        step: 1,
                        format: .number
                    )
                    Text(String(localized: "settings.text-editing.view.indent-width.spaces-unit", defaultValue: "spaces", comment: "Unit label for indent width value"))
                        .foregroundColor(.secondary)
                }
                .help(String(localized: "settings.text-editing.view.indent-width.description", defaultValue: "The number of spaces to insert when the tab key is pressed.", comment: "Description text for indent width setting"))
            }
        }
    }

    private var defaultTabWidth: some View {
        HStack(alignment: .top) {
            Stepper(
                String(localized: "settings.text-editing.view.tab-width", defaultValue: "Tab Width", comment: "Section label for tab width setting"),
                value: Binding<Double>(
                    get: { Double(textEditing.defaultTabWidth) },
                    set: { textEditing.defaultTabWidth = Int($0) }
                ),
                in: 1 ... 16,
                step: 1,
                format: .number
            )
            Text(String(localized: "settings.text-editing.indent.tab-width.suffix.spaces", defaultValue: "spaces", comment: "Suffix label for tab width value in spaces."))
                .foregroundColor(.secondary)
        }
        .help(String(localized: "settings.text-editing.indent.tab-width.description", defaultValue: "The visual width of tabs.", comment: "Description text for tab width setting."))
    }

    private var letterSpacing: some View {
        Stepper(
            String(localized: "settings.text-editing.typography.letter-spacing", defaultValue: "Letter Spacing", comment: "Label for letter spacing setting."),
            value: $textEditing.letterSpacing,
            in: 0.5 ... 2.0,
            step: 0.05,
            format: .number
        )
    }

    private var bracketPairHighlight: some View {
        Group {
            Picker(
                String(localized: "settings.text-editing.bracket-pair-highlight.title", defaultValue: "Bracket Pair Highlight", comment: "Section title for bracket pair highlight settings."),
                selection: $textEditing.bracketEmphasis.highlightType
            ) {
                Text(String(localized: "settings.text-editing.bracket-pair-highlight.style.disabled", defaultValue: "Disabled", comment: "Option label for disabled bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.disabled)
                Divider()
                Text(String(localized: "settings.text-editing.bracket-pair-highlight.style.bordered", defaultValue: "Bordered", comment: "Option label for bordered bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.bordered)
                Text(String(localized: "settings.text-editing.bracket-pair-highlight.style.flash", defaultValue: "Flash", comment: "Option label for flash bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.flash)
                Text(String(localized: "settings.text-editing.bracket-pair-highlight.style.underline", defaultValue: "Underline", comment: "Option label for underline bracket pair highlight style.")).tag(SettingsData.TextEditingSettings.BracketPairEmphasis.HighlightType.underline)
            }
            if [.bordered, .underline].contains(textEditing.bracketEmphasis.highlightType) {
                Toggle(String(localized: "settings.text-editing.bracket-pair-highlight.use-custom-color", defaultValue: "Use Custom Color", comment: "Toggle label to use custom bracket pair highlight color."), isOn: $textEditing.bracketEmphasis.useCustomColor)
                SettingsColorPicker(
                    String(localized: "settings.text-editing.bracket-pair-highlight.color", defaultValue: "Bracket Pair Highlight Color", comment: "Label for bracket pair highlight color picker."),
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

    private var showGutter: some View {
        Toggle(String(localized: "settings.text-editing.editor.show-gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing editor gutter."), isOn: $textEditing.showGutter)
            .help(String(localized: "settings.text-editing.editor.show-gutter.description", defaultValue: "The gutter displays line numbers and code folding regions.", comment: "Description for gutter visibility setting."))
    }

    private var showMinimap: some View {
        Toggle(String(localized: "settings.text-editing.editor.show-minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing editor minimap."), isOn: $textEditing.showMinimap)
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.editor.show-minimap.description", defaultValue: "The minimap gives you a high-level summary of your source code, with controls to quickly navigate your document.", comment: "Description for minimap setting."))
    }

    private var showFoldingRibbon: some View {
        Toggle(String(localized: "settings.text-editing.editor.show-code-folding-ribbon", defaultValue: "Show Code Folding Ribbon", comment: "Toggle label for showing code folding ribbon."), isOn: $textEditing.showFoldingRibbon)
            .disabled(!textEditing.showGutter) // Disabled when the gutter is disabled
            // swiftlint:disable:next line_length
            .help(String(localized: "settings.text-editing.editor.show-code-folding-ribbon.description", defaultValue: "The code folding ribbon lets you fold regions of code. When the gutter is disabled, the folding ribbon is disabled.", comment: "Description for code folding ribbon setting."))
    }

    @ViewBuilder private var reformatSettings: some View {
        Toggle(String(localized: "settings.text-editing.editor.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide."), isOn: $textEditing.showReformattingGuide)
            .help(String(localized: "settings.text-editing.editor.show-reformatting-guide.description", defaultValue: "Shows a vertical guide at the reformat column.", comment: "Description for reformatting guide setting."))

        Stepper(
            String(localized: "settings.text-editing.editor.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for reformat column setting."),
            value: Binding<Double>(
                get: { Double(textEditing.reformatAtColumn) },
                set: { textEditing.reformatAtColumn = Int($0) }
            ),
            in: 40 ... 200,
            step: 1,
            format: .number
        )
        .help(String(localized: "settings.text-editing.editor.reformat-at-column.description", defaultValue: "The column at which text should be reformatted.", comment: "Description for reformat column setting."))
    }

    private var invisibles: some View {
        HStack {
            Text(String(localized: "settings.text-editing.show-invisible-characters", defaultValue: "Show Invisible Characters", comment: "Toggle label for displaying invisible characters in editor"))
            Spacer()
            Toggle(isOn: $textEditing.invisibleCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingInvisibleCharacterSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.invisible-characters.configure", defaultValue: "Configure...", comment: "Button title for configuring invisible character display options"))
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

    private var warningCharacters: some View {
        HStack {
            Text(String(localized: "settings.text-editing.show-warning-characters", defaultValue: "Show Warning Characters", comment: "Toggle label for displaying warning characters in editor"))
            Spacer()
            Toggle(isOn: $textEditing.warningCharacters.enabled, label: { EmptyView() })
            Button {
                isShowingWarningCharactersSettings = true
            } label: {
                Text(String(localized: "settings.text-editing.warning-characters.configure", defaultValue: "Configure...", comment: "Button title for configuring warning character display options"))
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
