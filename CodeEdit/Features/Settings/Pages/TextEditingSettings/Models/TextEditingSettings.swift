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
                String(localized: "settings.text-editing.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Prefer indent using search key"),
                String(localized: "settings.text-editing.tab-width", defaultValue: "Tab Width", comment: "Tab width search key"),
                String(localized: "settings.text-editing.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Wrap lines search key"),
                String(localized: "settings.text-editing.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Editor overscroll search key"),
                String(localized: "settings.text-editing.font", defaultValue: "Font", comment: "Font search key"),
                String(localized: "settings.text-editing.font-size", defaultValue: "Font Size", comment: "Font size search key"),
                String(localized: "settings.text-editing.font-weight", defaultValue: "Font Weight", comment: "Font weight search key"),
                String(localized: "settings.text-editing.line-height", defaultValue: "Line Height", comment: "Line height search key"),
                String(localized: "settings.text-editing.letter-spacing", defaultValue: "Letter Spacing", comment: "Letter spacing search key"),
                String(localized: "settings.text-editing.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Autocomplete braces search key"),
                String(localized: "settings.text-editing.type-over-completion", defaultValue: "Enable type-over completion", comment: "Type-over completion search key"),
                String(localized: "settings.text-editing.bracket-pair-emphasis", defaultValue: "Bracket Pair Emphasis", comment: "Bracket pair emphasis search key"),
                String(localized: "settings.text-editing.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Bracket pair highlight search key"),
                String(localized: "settings.text-editing.show-gutter", defaultValue: "Show Gutter", comment: "Show gutter search key"),
                String(localized: "settings.text-editing.show-minimap", defaultValue: "Show Minimap", comment: "Show minimap search key"),
                String(localized: "settings.text-editing.reformat-at-column", defaultValue: "Reformat at Column", comment: "Reformat at column search key"),
                String(localized: "settings.text-editing.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Show reformatting guide search key"),
                String(localized: "settings.text-editing.invisibles", defaultValue: "Invisibles", comment: "Invisibles search key"),
                String(localized: "settings.text-editing.warning-characters", defaultValue: "Warning Characters", comment: "Warning characters search key")
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(localized: "settings.text-editing.system-cursor", defaultValue: "System Cursor", comment: "System cursor search key"))
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
                name: String(localized: "commands.text-editing.toggle-type-over-completion.name", defaultValue: "Toggle Type-Over Completion", comment: "Command name for toggle type-over completion"),
                title: String(localized: "commands.text-editing.toggle-type-over-completion.title", defaultValue: "Toggle Type-Over Completion", comment: "Command title for toggle type-over completion"),
                id: String(localized: "commands.text-editing.toggle-type-over-completion.id", defaultValue: "prefs.text_editing.type_over_completion", comment: "Command ID for toggle type-over completion"),
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "commands.text-editing.toggle-autocomplete-braces.name", defaultValue: "Toggle Autocomplete Braces", comment: "Command name for toggle autocomplete braces"),
                title: String(localized: "commands.text-editing.toggle-autocomplete-braces.title", defaultValue: "Toggle Autocomplete Braces", comment: "Command title for toggle autocomplete braces"),
                id: String(localized: "commands.text-editing.toggle-autocomplete-braces.id", defaultValue: "prefs.text_editing.autocomplete_braces", comment: "Command ID for toggle autocomplete braces"),
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "commands.text-editing.toggle-word-wrap.name", defaultValue: "Toggle Word Wrap", comment: "Command name for toggle word wrap"),
                title: String(localized: "commands.text-editing.toggle-word-wrap.title", defaultValue: "Toggle Word Wrap", comment: "Command title for toggle word wrap"),
                id: String(localized: "commands.text-editing.toggle-word-wrap.id", defaultValue: "prefs.text_editing.wrap_lines_to_editor_width", comment: "Command ID for toggle word wrap"),
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(localized: "commands.text-editing.toggle-minimap.name", defaultValue: "Toggle Minimap", comment: "Command name for toggle minimap"), title: String(localized: "commands.text-editing.toggle-minimap.title", defaultValue: "Toggle Minimap", comment: "Command title for toggle minimap"), id: String(localized: "commands.text-editing.toggle-minimap.id", defaultValue: "prefs.text_editing.toggle_minimap", comment: "Command ID for toggle minimap")) {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(localized: "commands.text-editing.toggle-gutter.name", defaultValue: "Toggle Gutter", comment: "Command name for toggle gutter"), title: String(localized: "commands.text-editing.toggle-gutter.title", defaultValue: "Toggle Gutter", comment: "Command title for toggle gutter"), id: String(localized: "commands.text-editing.toggle-gutter.id", defaultValue: "prefs.text_editing.toggle_gutter", comment: "Command ID for toggle gutter")) {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(localized: "commands.text-editing.toggle-folding-ribbon.name", defaultValue: "Toggle Folding Ribbon", comment: "Command name for toggle folding ribbon"),
                title: String(localized: "commands.text-editing.toggle-folding-ribbon.title", defaultValue: "Toggle Folding Ribbon", comment: "Command title for toggle folding ribbon"),
                id: String(localized: "commands.text-editing.toggle-folding-ribbon.id", defaultValue: "prefs.text_editing.toggle_folding_ribbon", comment: "Command ID for toggle folding ribbon")
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

            var spaceReplacement: String = String(localized: "settings.text-editing.invisibles.default-space-char", defaultValue: "·", comment: "Default space replacement character")
            var tabReplacement: String = String(localized: "settings.text-editing.invisibles.default-tab-char", defaultValue: "→", comment: "Default tab replacement character")

            // Controlled by `showLineEndings`
            var carriageReturnReplacement: String = String(localized: "settings.text-editing.invisibles.default-carriage-return-char", defaultValue: "↵", comment: "Default carriage return replacement character")
            var lineFeedReplacement: String = String(localized: "settings.text-editing.invisibles.default-line-feed-char", defaultValue: "¬", comment: "Default line feed replacement character")
            var paragraphSeparatorReplacement: String = String(localized: "settings.text-editing.invisibles.default-paragraph-separator-char", defaultValue: "¶", comment: "Default paragraph separator replacement character")
            var lineSeparatorReplacement: String = String(localized: "settings.text-editing.invisibles.default-line-separator-char", defaultValue: "⏎", comment: "Default line separator replacement character")
        }

        struct WarningCharacters: Equatable, Hashable, Codable {
            static let `default`: WarningCharacters = WarningCharacters(enabled: true, characters: [
                0x0003: String(localized: "settings.text-editing.warning-chars.end-of-text", defaultValue: "End of text", comment: "Warning character description for end of text"),

                0x00A0: String(localized: "settings.text-editing.warning-chars.non-breaking-space", defaultValue: "Non-breaking space", comment: "Warning character description for non-breaking space"),
                0x202F: String(localized: "settings.text-editing.warning-chars.narrow-non-breaking-space", defaultValue: "Narrow non-breaking space", comment: "Warning character description for narrow non-breaking space"),
                0x200B: String(localized: "settings.text-editing.warning-chars.zero-width-space", defaultValue: "Zero-width space", comment: "Warning character description for zero-width space"),
                0x200C: String(localized: "settings.text-editing.warning-chars.zero-width-non-joiner", defaultValue: "Zero-width non-joiner", comment: "Warning character description for zero-width non-joiner"),
                0x2029: String(localized: "settings.text-editing.warning-chars.paragraph-separator", defaultValue: "Paragraph separator", comment: "Warning character description for paragraph separator"),

                0x2013: String(localized: "settings.text-editing.warning-chars.em-dash", defaultValue: "Em-dash", comment: "Warning character description for em-dash"),
                0x00AD: String(localized: "settings.text-editing.warning-chars.soft-hyphen", defaultValue: "Soft hyphen", comment: "Warning character description for soft hyphen"),

                0x2018: String(localized: "settings.text-editing.warning-chars.left-single-quote", defaultValue: "Left single quote", comment: "Warning character description for left single quote"),
                0x2019: String(localized: "settings.text-editing.warning-chars.right-single-quote", defaultValue: "Right single quote", comment: "Warning character description for right single quote"),
                0x201C: String(localized: "settings.text-editing.warning-chars.left-double-quote", defaultValue: "Left double quote", comment: "Warning character description for left double quote"),
                0x201D: String(localized: "settings.text-editing.warning-chars.right-double-quote", defaultValue: "Right double quote", comment: "Warning character description for right double quote"),

                0x037E: String(localized: "settings.text-editing.warning-chars.greek-question-mark", defaultValue: "Greek Question Mark", comment: "Warning character description for Greek question mark")
            ])

            var enabled: Bool
            var characters: [UInt16: String]
        }
    }

    struct EditorFont: Codable, Hashable {
        /// The font size for the font
        var size: Double = 12

        /// The name of the custom font
        var name: String = String(localized: "settings.text-editing.font.sf-mono", defaultValue: "SF Mono", comment: "Default editor font name")

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
