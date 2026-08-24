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
                String(localized: "settings.text_editing.prefer_indent_using", defaultValue: "Prefer Indent Using", comment: "Setting label for preferred indentation method"),
                String(localized: "settings.text_editing.tab_width", defaultValue: "Tab Width", comment: "Setting label for tab width"),
                String(localized: "settings.text_editing.wrap_lines_to_editor_width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrapping lines to editor width"),
                String(localized: "settings.text_editing.editor_overscroll", defaultValue: "Editor Overscroll", comment: "Setting label for editor overscroll behavior"),
                String(localized: "settings.text_editing.font", defaultValue: "Font", comment: "Setting label for editor font family"),
                String(localized: "settings.text_editing.font_size", defaultValue: "Font Size", comment: "Setting label for editor font size"),
                String(localized: "settings.text_editing.font_weight", defaultValue: "Font Weight", comment: "Setting label for editor font weight"),
                String(localized: "settings.text_editing.line_height", defaultValue: "Line Height", comment: "Setting label for editor line height"),
                String(localized: "settings.text_editing.letter_spacing", defaultValue: "Letter Spacing", comment: "Setting label for editor letter spacing"),
                String(localized: "settings.text_editing.autocomplete_braces", defaultValue: "Autocomplete braces", comment: "Toggle label for automatically completing braces"),
                String(localized: "settings.text_editing.enable_type_over_completion", defaultValue: "Enable type-over completion", comment: "Toggle label for enabling type-over completion"),
                String(localized: "settings.text_editing.bracket_pair_emphasis", defaultValue: "Bracket Pair Emphasis", comment: "Setting label for bracket pair emphasis"),
                String(localized: "settings.text_editing.bracket_pair_highlight", defaultValue: "Bracket Pair Highlight", comment: "Setting label for bracket pair highlighting"),
                String(localized: "settings.text_editing.show_gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing editor gutter"),
                String(localized: "settings.text_editing.show_minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing editor minimap"),
                String(localized: "settings.text_editing.reformat_at_column", defaultValue: "Reformat at Column", comment: "Setting label for reformat column width"),
                String(localized: "settings.text_editing.show_reformatting_guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide"),
                String(localized: "settings.text_editing.invisibles", defaultValue: "Invisibles", comment: "Setting label for invisible character rendering"),
                String(localized: "settings.text_editing.warning_characters", defaultValue: "Warning Characters", comment: "Setting label for warning characters display")
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(localized: "settings.text_editing.system_cursor", defaultValue: "System Cursor", comment: "Option label for using system cursor style"))
            }
            return keys.map { NSLocalizedString($0, comment: "") }
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
                name: String(localized: "settings.text_editing.commands.toggle_type_over_completion.title", defaultValue: "Toggle Type-Over Completion", comment: "Command title to toggle type-over completion"),
                title: String(localized: "settings.text_editing.commands.toggle_type_over_completion.name", defaultValue: "Toggle Type-Over Completion", comment: "Command display name to toggle type-over completion"),
                id: "prefs.text_editing.type_over_completion",
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "settings.text_editing.commands.toggle_autocomplete_braces.title", defaultValue: "Toggle Autocomplete Braces", comment: "Command title to toggle autocomplete braces"),
                title: String(localized: "settings.text_editing.commands.toggle_autocomplete_braces.name", defaultValue: "Toggle Autocomplete Braces", comment: "Command display name to toggle autocomplete braces"),
                id: "prefs.text_editing.autocomplete_braces",
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "settings.text_editing.commands.toggle_word_wrap.title", defaultValue: "Toggle Word Wrap", comment: "Command title to toggle word wrap"),
                title: String(localized: "settings.text_editing.commands.toggle_word_wrap.name", defaultValue: "Toggle Word Wrap", comment: "Command display name to toggle word wrap"),
                id: "prefs.text_editing.wrap_lines_to_editor_width",
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(localized: "settings.text_editing.commands.toggle_minimap.title", defaultValue: "Toggle Minimap", comment: "Command title to toggle minimap visibility"), title: "Toggle Minimap", id: "prefs.text_editing.toggle_minimap") {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(localized: "settings.text_editing.commands.toggle_gutter.title", defaultValue: "Toggle Gutter", comment: "Command title to toggle gutter visibility"), title: "Toggle Gutter", id: "prefs.text_editing.toggle_gutter") {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(localized: "settings.text_editing.commands.toggle_folding_ribbon.title", defaultValue: "Toggle Folding Ribbon", comment: "Command title to toggle folding ribbon visibility"),
                title: String(localized: "settings.text_editing.commands.toggle_folding_ribbon.name", defaultValue: "Toggle Folding Ribbon", comment: "Command display name to toggle folding ribbon visibility"),
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
                0x0003: String(localized: "settings.text_editing.warning_characters.end_of_text", defaultValue: "End of text", comment: "Label for end-of-text warning character"),

                0x00A0: String(localized: "settings.text_editing.warning_characters.non_breaking_space", defaultValue: "Non-breaking space", comment: "Label for non-breaking space warning character"),
                0x202F: String(localized: "settings.text_editing.warning_characters.narrow_non_breaking_space", defaultValue: "Narrow non-breaking space", comment: "Label for narrow non-breaking space warning character"),
                0x200B: String(localized: "settings.text_editing.warning_characters.zero_width_space", defaultValue: "Zero-width space", comment: "Label for zero-width space warning character"),
                0x200C: String(localized: "settings.text_editing.warning_characters.zero_width_non_joiner", defaultValue: "Zero-width non-joiner", comment: "Label for zero-width non-joiner warning character"),
                0x2029: String(localized: "settings.text_editing.warning_characters.paragraph_separator", defaultValue: "Paragraph separator", comment: "Label for paragraph separator warning character"),

                0x2013: String(localized: "settings.text_editing.warning_characters.em_dash", defaultValue: "Em-dash", comment: "Label for em-dash warning character"),
                0x00AD: String(localized: "settings.text_editing.warning_characters.soft_hyphen", defaultValue: "Soft hyphen", comment: "Label for soft hyphen warning character"),

                0x2018: String(localized: "settings.text_editing.warning_characters.left_single_quote", defaultValue: "Left single quote", comment: "Label for left single quote warning character"),
                0x2019: String(localized: "settings.text_editing.warning_characters.right_single_quote", defaultValue: "Right single quote", comment: "Label for right single quote warning character"),
                0x201C: String(localized: "settings.text_editing.warning_characters.left_double_quote", defaultValue: "Left double quote", comment: "Label for left double quote warning character"),
                0x201D: String(localized: "settings.text_editing.warning_characters.right_double_quote", defaultValue: "Right double quote", comment: "Label for right double quote warning character"),

                0x037E: String(localized: "settings.text_editing.warning_characters.greek_question_mark", defaultValue: "Greek Question Mark", comment: "Label for Greek question mark warning character")
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
