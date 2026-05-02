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
                String(localized: "text-editing-settings.search.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Search key for prefer indent using setting"),
                String(localized: "text-editing-settings.search.tab-width", defaultValue: "Tab Width", comment: "Search key for tab width setting"),
                String(localized: "text-editing-settings.search.wrap-lines", defaultValue: "Wrap lines to editor width", comment: "Search key for wrap lines setting"),
                String(localized: "text-editing-settings.search.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Search key for editor overscroll setting"),
                String(localized: "text-editing-settings.search.font", defaultValue: "Font", comment: "Search key for font setting"),
                String(localized: "text-editing-settings.search.font-size", defaultValue: "Font Size", comment: "Search key for font size setting"),
                String(localized: "text-editing-settings.search.font-weight", defaultValue: "Font Weight", comment: "Search key for font weight setting"),
                String(localized: "text-editing-settings.search.line-height", defaultValue: "Line Height", comment: "Search key for line height setting"),
                String(localized: "text-editing-settings.search.letter-spacing", defaultValue: "Letter Spacing", comment: "Search key for letter spacing setting"),
                String(localized: "text-editing-settings.search.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Search key for autocomplete braces setting"),
                String(localized: "text-editing-settings.search.type-over-completion", defaultValue: "Enable type-over completion", comment: "Search key for type-over completion setting"),
                String(localized: "text-editing-settings.search.bracket-pair-emphasis", defaultValue: "Bracket Pair Emphasis", comment: "Search key for bracket pair emphasis setting"),
                String(localized: "text-editing-settings.search.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Search key for bracket pair highlight setting"),
                String(localized: "text-editing-settings.search.show-gutter", defaultValue: "Show Gutter", comment: "Search key for show gutter setting"),
                String(localized: "text-editing-settings.search.show-minimap", defaultValue: "Show Minimap", comment: "Search key for show minimap setting"),
                String(localized: "text-editing-settings.search.reformat-at-column", defaultValue: "Reformat at Column", comment: "Search key for reformat at column setting"),
                String(localized: "text-editing-settings.search.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Search key for show reformatting guide setting"),
                String(localized: "text-editing-settings.search.invisibles", defaultValue: "Invisibles", comment: "Search key for invisibles setting"),
                String(localized: "text-editing-settings.search.warning-characters", defaultValue: "Warning Characters", comment: "Search key for warning characters setting")
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(localized: "text-editing-settings.search.system-cursor", defaultValue: "System Cursor", comment: "Search key for system cursor setting"))
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
                name: String(localized: "text-editing-settings.command.toggle-type-over-completion.name", defaultValue: "Toggle Type-Over Completion", comment: "Command name for toggling type-over completion"),
                title: String(localized: "text-editing-settings.command.toggle-type-over-completion.title", defaultValue: "Toggle Type-Over Completion", comment: "Command title for toggling type-over completion"),
                id: String(localized: "text-editing-settings.command.toggle-type-over-completion.id", defaultValue: "prefs.text_editing.type_over_completion", comment: "Command ID for toggling type-over completion"),
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "text-editing-settings.command.toggle-autocomplete-braces.name", defaultValue: "Toggle Autocomplete Braces", comment: "Command name for toggling autocomplete braces"),
                title: String(localized: "text-editing-settings.command.toggle-autocomplete-braces.title", defaultValue: "Toggle Autocomplete Braces", comment: "Command title for toggling autocomplete braces"),
                id: String(localized: "text-editing-settings.command.toggle-autocomplete-braces.id", defaultValue: "prefs.text_editing.autocomplete_braces", comment: "Command ID for toggling autocomplete braces"),
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "text-editing-settings.command.toggle-word-wrap.name", defaultValue: "Toggle Word Wrap", comment: "Command name for toggling word wrap"),
                title: String(localized: "text-editing-settings.command.toggle-word-wrap.title", defaultValue: "Toggle Word Wrap", comment: "Command title for toggling word wrap"),
                id: String(localized: "text-editing-settings.command.toggle-word-wrap.id", defaultValue: "prefs.text_editing.wrap_lines_to_editor_width", comment: "Command ID for toggling word wrap"),
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(localized: "text-editing-settings.command.toggle-minimap.name", defaultValue: "Toggle Minimap", comment: "Command name for toggling minimap"), title: String(localized: "text-editing-settings.command.toggle-minimap.title", defaultValue: "Toggle Minimap", comment: "Command title for toggling minimap"), id: String(localized: "text-editing-settings.command.toggle-minimap.id", defaultValue: "prefs.text_editing.toggle_minimap", comment: "Command ID for toggling minimap")) {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(localized: "text-editing-settings.command.toggle-gutter.name", defaultValue: "Toggle Gutter", comment: "Command name for toggling gutter"), title: String(localized: "text-editing-settings.command.toggle-gutter.title", defaultValue: "Toggle Gutter", comment: "Command title for toggling gutter"), id: String(localized: "text-editing-settings.command.toggle-gutter.id", defaultValue: "prefs.text_editing.toggle_gutter", comment: "Command ID for toggling gutter")) {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(localized: "text-editing-settings.command.toggle-folding-ribbon.name", defaultValue: "Toggle Folding Ribbon", comment: "Command name for toggling folding ribbon"),
                title: String(localized: "text-editing-settings.command.toggle-folding-ribbon.title", defaultValue: "Toggle Folding Ribbon", comment: "Command title for toggling folding ribbon"),
                id: String(localized: "text-editing-settings.command.toggle-folding-ribbon.id", defaultValue: "prefs.text_editing.toggle_folding_ribbon", comment: "Command ID for toggling folding ribbon")
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
            var color: Theme.Attributes = Theme.Attributes(color: String(localized: "text-editing-settings.bracket-pair-emphasis.default-color", defaultValue: "FFFFFF", comment: "Default color for bracket pair emphasis"), bold: false, italic: false)

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

            var spaceReplacement: String = String(localized: "text-editing-settings.invisible-characters.space-replacement", defaultValue: "·", comment: "Default replacement character for spaces")
            var tabReplacement: String = String(localized: "text-editing-settings.invisible-characters.tab-replacement", defaultValue: "→", comment: "Default replacement character for tabs")

            // Controlled by `showLineEndings`
            var carriageReturnReplacement: String = String(localized: "text-editing-settings.invisible-characters.carriage-return-replacement", defaultValue: "↵", comment: "Default replacement character for carriage returns")
            var lineFeedReplacement: String = String(localized: "text-editing-settings.invisible-characters.line-feed-replacement", defaultValue: "¬", comment: "Default replacement character for line feeds")
            var paragraphSeparatorReplacement: String = String(localized: "text-editing-settings.invisible-characters.paragraph-separator-replacement", defaultValue: "¶", comment: "Default replacement character for paragraph separators")
            var lineSeparatorReplacement: String = String(localized: "text-editing-settings.invisible-characters.line-separator-replacement", defaultValue: "⏎", comment: "Default replacement character for line separators")
        }

        struct WarningCharacters: Equatable, Hashable, Codable {
            static let `default`: WarningCharacters = WarningCharacters(enabled: true, characters: [
                0x0003: String(localized: "text-editing-settings.warning-characters.end-of-text", defaultValue: "End of text", comment: "Description for end of text character"),

                0x00A0: String(localized: "text-editing-settings.warning-characters.non-breaking-space", defaultValue: "Non-breaking space", comment: "Description for non-breaking space character"),
                0x202F: String(localized: "text-editing-settings.warning-characters.narrow-non-breaking-space", defaultValue: "Narrow non-breaking space", comment: "Description for narrow non-breaking space character"),
                0x200B: String(localized: "text-editing-settings.warning-characters.zero-width-space", defaultValue: "Zero-width space", comment: "Description for zero-width space character"),
                0x200C: String(localized: "text-editing-settings.warning-characters.zero-width-non-joiner", defaultValue: "Zero-width non-joiner", comment: "Description for zero-width non-joiner character"),
                0x2029: String(localized: "text-editing-settings.warning-characters.paragraph-separator", defaultValue: "Paragraph separator", comment: "Description for paragraph separator character"),

                0x2013: String(localized: "text-editing-settings.warning-characters.em-dash", defaultValue: "Em-dash", comment: "Description for em-dash character"),
                0x00AD: String(localized: "text-editing-settings.warning-characters.soft-hyphen", defaultValue: "Soft hyphen", comment: "Description for soft hyphen character"),

                0x2018: String(localized: "text-editing-settings.warning-characters.left-single-quote", defaultValue: "Left single quote", comment: "Description for left single quote character"),
                0x2019: String(localized: "text-editing-settings.warning-characters.right-single-quote", defaultValue: "Right single quote", comment: "Description for right single quote character"),
                0x201C: String(localized: "text-editing-settings.warning-characters.left-double-quote", defaultValue: "Left double quote", comment: "Description for left double quote character"),
                0x201D: String(localized: "text-editing-settings.warning-characters.right-double-quote", defaultValue: "Right double quote", comment: "Description for right double quote character"),

                0x037E: String(localized: "text-editing-settings.warning-characters.greek-question-mark", defaultValue: "Greek Question Mark", comment: "Description for greek question mark character")
            ])

            var enabled: Bool
            var characters: [UInt16: String]
        }
    }

    struct EditorFont: Codable, Hashable {
        /// The font size for the font
        var size: Double = 12

        /// The name of the custom font
        var name: String = String(localized: "text-editing-settings.editor-font.default-name", defaultValue: "SF Mono", comment: "Default font name for editor")

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
