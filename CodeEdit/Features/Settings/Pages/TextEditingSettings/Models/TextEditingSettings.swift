//
//  TextEditingPreferences.swift
//  CodeEditModules/Settings
//
//  Created by Nanashi Li on 2022/04/08.
//

import AppKit
import Foundation

extension SettingsData {

    /// The global settings for text editing
    struct TextEditingSettings: Codable, Hashable, SearchableSettingsPage {

        var searchKeys: [String] {
            var keys = [
                String(localized: "textediting.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Label for indent type picker"),
                String(localized: "textediting.tab-width", defaultValue: "Tab Width", comment: "Label for tab width stepper"),
                String(localized: "textediting.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Toggle for wrapping lines to editor width"),
                String(localized: "textediting.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Label for editor overscroll picker"),
                "Font",
                String(localized: "textediting.font-size", defaultValue: "Font Size", comment: "Label for font size stepper"),
                "Font Weight",
                String(localized: "textediting.line-height", defaultValue: "Line Height", comment: "Label for line height stepper"),
                String(localized: "textediting.letter-spacing", defaultValue: "Letter Spacing", comment: "Label for letter spacing stepper"),
                String(localized: "textediting.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Toggle for autocompleting braces"),
                String(localized: "textediting.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Toggle for enabling type-over completion"),
                "Bracket Pair Emphasis",
                String(localized: "textediting.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Label for bracket pair highlight picker"),
                String(localized: "textediting.show-gutter", defaultValue: "Show Gutter", comment: "Toggle for showing gutter"),
                String(localized: "textediting.show-minimap", defaultValue: "Show Minimap", comment: "Toggle for showing minimap"),
                String(localized: "textediting.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for reformat at column stepper"),
                String(localized: "textediting.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle for showing reformatting guide"),
                "Invisibles",
                String(localized: "textediting.warning-characters", defaultValue: "Warning Characters", comment: "Label for warning characters settings")
            ]
            if #available(macOS 14.0, *) {
                keys.append("System Cursor")
            }
            return keys
        }

        /// An integer indicating how many spaces a `tab` will appear as visually.
        var defaultTabWidth: Int = 4

        /// The behavior of a `tab` keypress. If `.tab`, will insert a tab character. If `.spaces` will insert
        /// `.spaceCount` spaces instead.
        var indentOption: IndentOption = IndentOption(indentType: .spaces, spaceCount: 4)

        /// The font to use in editor.
        var font: EditorFont = .init()

        /// A flag indicating whether type-over completion is enabled
        var enableTypeOverCompletion: Bool = true

        /// A flag indicating whether braces are automatically completed
        var autocompleteBraces: Bool = true

        /// A flag indicating whether to wrap lines to editor width
        var wrapLinesToEditorWidth: Bool = true

        /// The percentage of overscroll to apply to the text view
        var overscroll: OverscrollOption = .medium

        /// A multiplier for setting the line height. Defaults to `1.2`
        var lineHeightMultiple: Double = 1.2

        /// A multiplier for setting the letter spacing, `1` being no spacing and
        /// `2` is one character of spacing between letters, defaults to `1`.
        var letterSpacing: Double = 1.0

        /// The behavior of bracket pair highlights.
        var bracketEmphasis: BracketPairEmphasis = BracketPairEmphasis()

        /// Use the system cursor for the source editor.
        var useSystemCursor: Bool = true

        /// Toggle the gutter in the editor.
        var showGutter: Bool = true

        /// Toggle the minimap in the editor.
        var showMinimap: Bool = true

        /// Toggle the code folding ribbon.
        var showFoldingRibbon: Bool = true

        /// The column at which to reformat text
        var reformatAtColumn: Int = 80

        /// Show the reformatting guide in the editor
        var showReformattingGuide: Bool = false

        var invisibleCharacters: InvisibleCharactersConfig = .default

        /// Map of unicode character codes to a note about them
        var warningCharacters: WarningCharacters = .default

        /// Default initializer
        init() {
            self.populateCommands()
        }

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws { // swiftlint:disable:this function_body_length
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.defaultTabWidth = try container.decodeIfPresent(Int.self, forKey: .defaultTabWidth) ?? 4
            self.indentOption = try container.decodeIfPresent(
                IndentOption.self,
                forKey: .indentOption
            ) ?? IndentOption(indentType: .spaces, spaceCount: 4)
            self.font = try container.decodeIfPresent(EditorFont.self, forKey: .font) ?? .init()
            self.enableTypeOverCompletion = try container.decodeIfPresent(
                Bool.self,
                forKey: .enableTypeOverCompletion
            ) ?? true
            self.autocompleteBraces = try container.decodeIfPresent(
                Bool.self,
                forKey: .autocompleteBraces
            ) ?? true
            self.wrapLinesToEditorWidth = try container.decodeIfPresent(
                Bool.self,
                forKey: .wrapLinesToEditorWidth
            ) ?? true
            self.overscroll = try container.decodeIfPresent(
                OverscrollOption.self,
                forKey: .overscroll
            ) ?? .medium
            self.lineHeightMultiple = try container.decodeIfPresent(
                Double.self,
                forKey: .lineHeightMultiple
            ) ?? 1.2
            self.letterSpacing = try container.decodeIfPresent(
                Double.self,
                forKey: .letterSpacing
            ) ?? 1
            self.bracketEmphasis = try container.decodeIfPresent(
                BracketPairEmphasis.self,
                forKey: .bracketEmphasis
            ) ?? BracketPairEmphasis()
            if #available(macOS 14, *) {
                self.useSystemCursor = try container.decodeIfPresent(Bool.self, forKey: .useSystemCursor) ?? true
            } else {
                self.useSystemCursor = false
            }

            self.showGutter = try container.decodeIfPresent(Bool.self, forKey: .showGutter) ?? true
            self.showMinimap = try container.decodeIfPresent(Bool.self, forKey: .showMinimap) ?? true
            self.showFoldingRibbon = try container.decodeIfPresent(Bool.self, forKey: .showFoldingRibbon) ?? true
            self.reformatAtColumn = try container.decodeIfPresent(Int.self, forKey: .reformatAtColumn) ?? 80
            self.showReformattingGuide = try container.decodeIfPresent(
                Bool.self,
                forKey: .showReformattingGuide
            ) ?? false
            self.invisibleCharacters = try container.decodeIfPresent(
                InvisibleCharactersConfig.self,
                forKey: .invisibleCharacters
            ) ?? .default
            self.warningCharacters = try container.decodeIfPresent(
                WarningCharacters.self,
                forKey: .warningCharacters
            ) ?? .default

            self.populateCommands()
        }

        /// Adds toggle-able preferences to the command palette via shared `CommandManager`
        private func populateCommands() {
            let mgr = CommandManager.shared

            mgr.addCommand(
                name: "Toggle Type-Over Completion",
                title: "Toggle Type-Over Completion",
                id: "prefs.text_editing.type_over_completion",
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: "Toggle Autocomplete Braces",
                title: "Toggle Autocomplete Braces",
                id: "prefs.text_editing.autocomplete_braces",
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: "Toggle Word Wrap",
                title: "Toggle Word Wrap",
                id: "prefs.text_editing.wrap_lines_to_editor_width",
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: "Toggle Minimap", title: "Toggle Minimap", id: "prefs.text_editing.toggle_minimap") {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: "Toggle Gutter", title: "Toggle Gutter", id: "prefs.text_editing.toggle_gutter") {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: "Toggle Folding Ribbon",
                title: "Toggle Folding Ribbon",
                id: "prefs.text_editing.toggle_folding_ribbon"
            ) {
                Settings[\.textEditing].showFoldingRibbon.toggle()
            }
        }

        struct IndentOption: Codable, Hashable {
            var indentType: IndentType
            // Kept even when `indentType` is `.tab` to retain the user's
            // settings when changing `indentType`.
            var spaceCount: Int = 4

            enum IndentType: String, Codable {
                case tab
                case spaces
            }
        }

        struct BracketPairEmphasis: Codable, Hashable {
            /// The type of highlight to use
            var highlightType: HighlightType = .flash
            var useCustomColor: Bool = false
            /// The color to use for the highlight.
            var color: Theme.Attributes = Theme.Attributes(color: "FFFFFF", bold: false, italic: false)

            enum HighlightType: String, Codable {
                case disabled
                case bordered
                case flash
                case underline
            }
        }

        enum OverscrollOption: String, Codable {
            case none
            case small
            case medium
            case large

            var overscrollPercentage: CGFloat {
                switch self {
                case .none: return 0
                case .small: return 0.25
                case .medium: return 0.5
                case .large: return 0.75
                }
            }
        }

        struct InvisibleCharactersConfig: Equatable, Hashable, Codable {
            static var `default`: InvisibleCharactersConfig = {
                InvisibleCharactersConfig(
                    enabled: false,
                    showSpaces: true,
                    showTabs: true,
                    showLineEndings: true
                )
            }()

            var enabled: Bool

            var showSpaces: Bool
            var showTabs: Bool
            var showLineEndings: Bool

            var spaceReplacement: String = "·"
            var tabReplacement: String = "→"

            // Controlled by `showLineEndings`
            var carriageReturnReplacement: String = "↵"
            var lineFeedReplacement: String = "¬"
            var paragraphSeparatorReplacement: String = "¶"
            var lineSeparatorReplacement: String = "⏎"
        }

        struct WarningCharacters: Equatable, Hashable, Codable {
            static let `default`: WarningCharacters = WarningCharacters(enabled: true, characters: [
                0x0003: String(localized: "textediting.warning-char.end-of-text", defaultValue: "End of text", comment: "Warning character description: End of text"),

                0x00A0: String(localized: "textediting.warning-char.non-breaking-space", defaultValue: "Non-breaking space", comment: "Warning character description: Non-breaking space"),
                0x202F: String(localized: "textediting.warning-char.narrow-non-breaking-space", defaultValue: "Narrow non-breaking space", comment: "Warning character description: Narrow non-breaking space"),
                0x200B: String(localized: "textediting.warning-char.zero-width-space", defaultValue: "Zero-width space", comment: "Warning character description: Zero-width space"),
                0x200C: String(localized: "textediting.warning-char.zero-width-non-joiner", defaultValue: "Zero-width non-joiner", comment: "Warning character description: Zero-width non-joiner"),
                0x2029: String(localized: "textediting.warning-char.paragraph-separator", defaultValue: "Paragraph separator", comment: "Warning character description: Paragraph separator"),

                0x2013: String(localized: "textediting.warning-char.em-dash", defaultValue: "Em-dash", comment: "Warning character description: Em-dash"),
                0x00AD: String(localized: "textediting.warning-char.soft-hyphen", defaultValue: "Soft hyphen", comment: "Warning character description: Soft hyphen"),

                0x2018: String(localized: "textediting.warning-char.left-single-quote", defaultValue: "Left single quote", comment: "Warning character description: Left single quote"),
                0x2019: String(localized: "textediting.warning-char.right-single-quote", defaultValue: "Right single quote", comment: "Warning character description: Right single quote"),
                0x201C: String(localized: "textediting.warning-char.left-double-quote", defaultValue: "Left double quote", comment: "Warning character description: Left double quote"),
                0x201D: String(localized: "textediting.warning-char.right-double-quote", defaultValue: "Right double quote", comment: "Warning character description: Right double quote"),

                0x037E: String(localized: "textediting.warning-char.greek-question-mark", defaultValue: "Greek Question Mark", comment: "Warning character description: Greek Question Mark")
            ])

            var enabled: Bool
            var characters: [UInt16: String]
        }
    }

    struct EditorFont: Codable, Hashable {
        /// The font size for the font
        var size: Double = 12

        /// The name of the custom font
        var name: String = "SF Mono"

        /// The weight of the custom font
        var weight: NSFont.Weight = .medium

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.size = try container.decodeIfPresent(Double.self, forKey: .size) ?? size
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? name
            self.weight = try container.decodeIfPresent(NSFont.Weight.self, forKey: .weight) ?? weight
        }

        /// Returns an NSFont representation of the current configuration.
        ///
        /// Returns the custom font, if enabled and able to be instantiated.
        /// Otherwise returns a default system font monospaced.
        var current: NSFont {
            let customFont = NSFont(name: name, size: size)?.withWeight(weight: weight)
            return customFont ?? NSFont.monospacedSystemFont(ofSize: size, weight: .medium)
        }
    }
}
