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
                String(localized: "text_editing.search.prefer_indent_using", defaultValue: "Prefer Indent Using", comment: "Search key for indent preference"),
                String(localized: "text_editing.search.tab_width", defaultValue: "Tab Width", comment: "Search key for tab width"),
                String(localized: "text_editing.search.wrap_lines", defaultValue: "Wrap lines to editor width", comment: "Search key for line wrapping"),
                String(localized: "text_editing.search.editor_overscroll", defaultValue: "Editor Overscroll", comment: "Search key for overscroll"),
                String(localized: "text_editing.search.font", defaultValue: "Font", comment: "Search key for font"),
                String(localized: "text_editing.search.font_size", defaultValue: "Font Size", comment: "Search key for font size"),
                String(localized: "text_editing.search.font_weight", defaultValue: "Font Weight", comment: "Search key for font weight"),
                String(localized: "text_editing.search.line_height", defaultValue: "Line Height", comment: "Search key for line height"),
                String(localized: "text_editing.search.letter_spacing", defaultValue: "Letter Spacing", comment: "Search key for letter spacing"),
                String(localized: "text_editing.search.autocomplete_braces", defaultValue: "Autocomplete braces", comment: "Search key for autocomplete braces"),
                String(localized: "text_editing.search.type_over_completion", defaultValue: "Enable type-over completion", comment: "Search key for type-over completion"),
                String(localized: "text_editing.search.bracket_pair_emphasis", defaultValue: "Bracket Pair Emphasis", comment: "Search key for bracket pair emphasis"),
                String(localized: "text_editing.search.bracket_pair_highlight", defaultValue: "Bracket Pair Highlight", comment: "Search key for bracket pair highlight"),
                String(localized: "text_editing.search.show_gutter", defaultValue: "Show Gutter", comment: "Search key for show gutter"),
                String(localized: "text_editing.search.show_minimap", defaultValue: "Show Minimap", comment: "Search key for show minimap"),
                String(localized: "text_editing.search.reformat_at_column", defaultValue: "Reformat at Column", comment: "Search key for reformat at column"),
                String(localized: "text_editing.search.show_reformatting_guide", defaultValue: "Show Reformatting Guide", comment: "Search key for reformatting guide"),
                String(localized: "text_editing.search.invisibles", defaultValue: "Invisibles", comment: "Search key for invisible characters"),
                String(localized: "text_editing.search.warning_characters", defaultValue: "Warning Characters", comment: "Search key for warning characters")
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(localized: "text_editing.search.system_cursor", defaultValue: "System Cursor", comment: "Search key for system cursor"))
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
                name: String(localized: "text_editing.command.toggle_type_over_completion.name", defaultValue: "Toggle Type-Over Completion", comment: "Command name for toggle type-over completion"),
                title: String(localized: "text_editing.command.toggle_type_over_completion.title", defaultValue: "Toggle Type-Over Completion", comment: "Command title for toggle type-over completion"),
                id: String(localized: "text_editing.command.toggle_type_over_completion.id", defaultValue: "prefs.text_editing.type_over_completion", comment: "Command ID for toggle type-over completion"),
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "text_editing.command.toggle_autocomplete_braces.name", defaultValue: "Toggle Autocomplete Braces", comment: "Command name for toggle autocomplete braces"),
                title: String(localized: "text_editing.command.toggle_autocomplete_braces.title", defaultValue: "Toggle Autocomplete Braces", comment: "Command title for toggle autocomplete braces"),
                id: String(localized: "text_editing.command.toggle_autocomplete_braces.id", defaultValue: "prefs.text_editing.autocomplete_braces", comment: "Command ID for toggle autocomplete braces"),
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "text_editing.command.toggle_word_wrap.name", defaultValue: "Toggle Word Wrap", comment: "Command name for toggle word wrap"),
                title: String(localized: "text_editing.command.toggle_word_wrap.title", defaultValue: "Toggle Word Wrap", comment: "Command title for toggle word wrap"),
                id: String(localized: "text_editing.command.toggle_word_wrap.id", defaultValue: "prefs.text_editing.wrap_lines_to_editor_width", comment: "Command ID for toggle word wrap"),
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(localized: "text_editing.command.toggle_minimap.name", defaultValue: "Toggle Minimap", comment: "Command name for toggle minimap"), title: String(localized: "text_editing.command.toggle_minimap.title", defaultValue: "Toggle Minimap", comment: "Command title for toggle minimap"), id: String(localized: "text_editing.command.toggle_minimap.id", defaultValue: "prefs.text_editing.toggle_minimap", comment: "Command ID for toggle minimap")) {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(localized: "text_editing.command.toggle_gutter.name", defaultValue: "Toggle Gutter", comment: "Command name for toggle gutter"), title: String(localized: "text_editing.command.toggle_gutter.title", defaultValue: "Toggle Gutter", comment: "Command title for toggle gutter"), id: String(localized: "text_editing.command.toggle_gutter.id", defaultValue: "prefs.text_editing.toggle_gutter", comment: "Command ID for toggle gutter")) {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(localized: "text_editing.command.toggle_folding_ribbon.name", defaultValue: "Toggle Folding Ribbon", comment: "Command name for toggle folding ribbon"),
                title: String(localized: "text_editing.command.toggle_folding_ribbon.title", defaultValue: "Toggle Folding Ribbon", comment: "Command title for toggle folding ribbon"),
                id: String(localized: "text_editing.command.toggle_folding_ribbon.id", defaultValue: "prefs.text_editing.toggle_folding_ribbon", comment: "Command ID for toggle folding ribbon")
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

            var spaceReplacement: String = String(localized: "text_editing.invisible_chars.space_replacement", defaultValue: "·", comment: "Character used to represent spaces when invisible characters are shown")
            var tabReplacement: String = String(localized: "text_editing.invisible_chars.tab_replacement", defaultValue: "→", comment: "Character used to represent tabs when invisible characters are shown")

            // Controlled by `showLineEndings`
            var carriageReturnReplacement: String = String(localized: "text_editing.invisible_chars.carriage_return_replacement", defaultValue: "↵", comment: "Character used to represent carriage returns when invisible characters are shown")
            var lineFeedReplacement: String = String(localized: "text_editing.invisible_chars.line_feed_replacement", defaultValue: "¬", comment: "Character used to represent line feeds when invisible characters are shown")
            var paragraphSeparatorReplacement: String = String(localized: "text_editing.invisible_chars.paragraph_separator_replacement", defaultValue: "¶", comment: "Character used to represent paragraph separators when invisible characters are shown")
            var lineSeparatorReplacement: String = String(localized: "text_editing.invisible_chars.line_separator_replacement", defaultValue: "⏎", comment: "Character used to represent line separators when invisible characters are shown")
        }

        struct WarningCharacters: Equatable, Hashable, Codable {
            static let `default`: WarningCharacters = WarningCharacters(enabled: true, characters: [
                0x0003: String(localized: "text_editing.warning_chars.end_of_text", defaultValue: "End of text", comment: "Description for U+0003 (End of text) warning character"),

                0x00A0: String(localized: "text_editing.warning_chars.non_breaking_space", defaultValue: "Non-breaking space", comment: "Description for U+00A0 (Non-breaking space) warning character"),
                0x202F: String(localized: "text_editing.warning_chars.narrow_non_breaking_space", defaultValue: "Narrow non-breaking space", comment: "Description for U+202F (Narrow non-breaking space) warning character"),
                0x200B: String(localized: "text_editing.warning_chars.zero_width_space", defaultValue: "Zero-width space", comment: "Description for U+200B (Zero-width space) warning character"),
                0x200C: String(localized: "text_editing.warning_chars.zero_width_non_joiner", defaultValue: "Zero-width non-joiner", comment: "Description for U+200C (Zero-width non-joiner) warning character"),
                0x2029: String(localized: "text_editing.warning_chars.paragraph_separator", defaultValue: "Paragraph separator", comment: "Description for U+2029 (Paragraph separator) warning character"),

                0x2013: String(localized: "text_editing.warning_chars.em_dash", defaultValue: "Em-dash", comment: "Description for U+2013 (Em-dash) warning character"),
                0x00AD: String(localized: "text_editing.warning_chars.soft_hyphen", defaultValue: "Soft hyphen", comment: "Description for U+00AD (Soft hyphen) warning character"),

                0x2018: String(localized: "text_editing.warning_chars.left_single_quote", defaultValue: "Left single quote", comment: "Description for U+2018 (Left single quote) warning character"),
                0x2019: String(localized: "text_editing.warning_chars.right_single_quote", defaultValue: "Right single quote", comment: "Description for U+2019 (Right single quote) warning character"),
                0x201C: String(localized: "text_editing.warning_chars.left_double_quote", defaultValue: "Left double quote", comment: "Description for U+201C (Left double quote) warning character"),
                0x201D: String(localized: "text_editing.warning_chars.right_double_quote", defaultValue: "Right double quote", comment: "Description for U+201D (Right double quote) warning character"),

                0x037E: String(localized: "text_editing.warning_chars.greek_question_mark", defaultValue: "Greek Question Mark", comment: "Description for U+037E (Greek Question Mark) warning character")
            ])

            var enabled: Bool
            var characters: [UInt16: String]
        }
    }

    struct EditorFont: Codable, Hashable {
        /// The font size for the font
        var size: Double = 12

        /// The name of the custom font
        var name: String = String(localized: "text_editing.editor_font.default_name", defaultValue: "SF Mono", comment: "Default font name for the code editor")

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
