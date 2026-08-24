//
//  TextEditingSettings.swift
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
                String(localized: "settings.text-editing.prefer-indent-using", defaultValue: "Prefer Indent Using", comment: "Label for preferred indentation method setting"),
                String(localized: "settings.text-editing.tab-width", defaultValue: "Tab Width", comment: "Label for tab width setting"),
                String(localized: "settings.text-editing.wrap-lines-to-editor-width", defaultValue: "Wrap lines to editor width", comment: "Toggle label for wrapping lines to editor width"),
                String(localized: "settings.text-editing.editor-overscroll", defaultValue: "Editor Overscroll", comment: "Label for editor overscroll setting"),
                String(localized: "settings.text-editing.font", defaultValue: "Font", comment: "Label for editor font family setting"),
                String(localized: "settings.text-editing.font-size", defaultValue: "Font Size", comment: "Label for editor font size setting"),
                String(localized: "settings.text-editing.font-weight", defaultValue: "Font Weight", comment: "Label for editor font weight setting"),
                String(localized: "settings.text-editing.line-height", defaultValue: "Line Height", comment: "Label for editor line height setting"),
                String(localized: "settings.text-editing.letter-spacing", defaultValue: "Letter Spacing", comment: "Label for editor letter spacing setting"),
                String(localized: "settings.text-editing.autocomplete-braces", defaultValue: "Autocomplete braces", comment: "Toggle label for automatically completing braces"),
                String(localized: "settings.text-editing.enable-type-over-completion", defaultValue: "Enable type-over completion", comment: "Toggle label for enabling type-over completion in editor"),
                String(localized: "settings.text-editing.bracket-pair-emphasis", defaultValue: "Bracket Pair Emphasis", comment: "Label for bracket pair emphasis setting"),
                String(localized: "settings.text-editing.bracket-pair-highlight", defaultValue: "Bracket Pair Highlight", comment: "Label for bracket pair highlight setting"),
                String(localized: "settings.text-editing.show-gutter", defaultValue: "Show Gutter", comment: "Toggle label for showing editor gutter"),
                String(localized: "settings.text-editing.show-minimap", defaultValue: "Show Minimap", comment: "Toggle label for showing editor minimap"),
                String(localized: "settings.text-editing.reformat-at-column", defaultValue: "Reformat at Column", comment: "Label for editor reformat column setting"),
                String(localized: "settings.text-editing.show-reformatting-guide", defaultValue: "Show Reformatting Guide", comment: "Toggle label for showing reformatting guide in editor"),
                String(localized: "settings.text-editing.invisibles", defaultValue: "Invisibles", comment: "Label for invisible character display setting"),
                String(localized: "settings.text-editing.warning-characters", defaultValue: "Warning Characters", comment: "Label for warning characters display setting"),
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(localized: "settings.text-editing.system-cursor", defaultValue: "System Cursor", comment: "Label for using system cursor style in editor"))
            }
            return keys.map { NSLocalizedString($0, comment: "") }
        }

        /// An integer indicating how many spaces a `tab` will appear as visually.
        var defaultTabWidth: Int = 4

        /// The behavior of a `tab` keypress. If `.tab`, will insert a tab character. If `.spaces` will insert
        /// `.spaceCount` spaces instead.
        var indentOption: IndentOption = .init(indentType: .spaces, spaceCount: 4)

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
        var bracketEmphasis: BracketPairEmphasis = .init()

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
            populateCommands()
        }

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws { // swiftlint:disable:this function_body_length
            let container = try decoder.container(keyedBy: CodingKeys.self)
            defaultTabWidth = try container.decodeIfPresent(Int.self, forKey: .defaultTabWidth) ?? 4
            indentOption = try container.decodeIfPresent(
                IndentOption.self,
                forKey: .indentOption
            ) ?? IndentOption(indentType: .spaces, spaceCount: 4)
            font = try container.decodeIfPresent(EditorFont.self, forKey: .font) ?? .init()
            enableTypeOverCompletion = try container.decodeIfPresent(
                Bool.self,
                forKey: .enableTypeOverCompletion
            ) ?? true
            autocompleteBraces = try container.decodeIfPresent(
                Bool.self,
                forKey: .autocompleteBraces
            ) ?? true
            wrapLinesToEditorWidth = try container.decodeIfPresent(
                Bool.self,
                forKey: .wrapLinesToEditorWidth
            ) ?? true
            overscroll = try container.decodeIfPresent(
                OverscrollOption.self,
                forKey: .overscroll
            ) ?? .medium
            lineHeightMultiple = try container.decodeIfPresent(
                Double.self,
                forKey: .lineHeightMultiple
            ) ?? 1.2
            letterSpacing = try container.decodeIfPresent(
                Double.self,
                forKey: .letterSpacing
            ) ?? 1
            bracketEmphasis = try container.decodeIfPresent(
                BracketPairEmphasis.self,
                forKey: .bracketEmphasis
            ) ?? BracketPairEmphasis()
            if #available(macOS 14, *) {
                useSystemCursor = try container.decodeIfPresent(Bool.self, forKey: .useSystemCursor) ?? true
            } else {
                useSystemCursor = false
            }

            showGutter = try container.decodeIfPresent(Bool.self, forKey: .showGutter) ?? true
            showMinimap = try container.decodeIfPresent(Bool.self, forKey: .showMinimap) ?? true
            showFoldingRibbon = try container.decodeIfPresent(Bool.self, forKey: .showFoldingRibbon) ?? true
            reformatAtColumn = try container.decodeIfPresent(Int.self, forKey: .reformatAtColumn) ?? 80
            showReformattingGuide = try container.decodeIfPresent(
                Bool.self,
                forKey: .showReformattingGuide
            ) ?? false
            invisibleCharacters = try container.decodeIfPresent(
                InvisibleCharactersConfig.self,
                forKey: .invisibleCharacters
            ) ?? .default
            warningCharacters = try container.decodeIfPresent(
                WarningCharacters.self,
                forKey: .warningCharacters
            ) ?? .default

            populateCommands()
        }

        /// Adds toggle-able preferences to the command palette via shared `CommandManager`
        private func populateCommands() {
            let mgr = CommandManager.shared

            mgr.addCommand(
                name: String(localized: "settings.text-editing.commands.toggle-type-over-completion.title", defaultValue: "Toggle Type-Over Completion", comment: "Command title for toggling type-over completion"),
                title: String(localized: "settings.text-editing.commands.toggle-type-over-completion.description", defaultValue: "Toggle Type-Over Completion", comment: "Command description for toggling type-over completion"),
                id: "prefs.text_editing.type_over_completion",
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "settings.text-editing.commands.toggle-autocomplete-braces.title", defaultValue: "Toggle Autocomplete Braces", comment: "Command title for toggling autocomplete braces"),
                title: String(localized: "settings.text-editing.commands.toggle-autocomplete-braces.description", defaultValue: "Toggle Autocomplete Braces", comment: "Command description for toggling autocomplete braces"),
                id: "prefs.text_editing.autocomplete_braces",
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(localized: "settings.text-editing.commands.toggle-word-wrap.title", defaultValue: "Toggle Word Wrap", comment: "Command title for toggling word wrap"),
                title: String(localized: "settings.text-editing.commands.toggle-word-wrap.description", defaultValue: "Toggle Word Wrap", comment: "Command description for toggling word wrap"),
                id: "prefs.text_editing.wrap_lines_to_editor_width",
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(localized: "settings.text-editing.commands.toggle-minimap.title", defaultValue: String(localized: "settings.text-editing.commands.toggle-minimap.description", defaultValue: "Toggle Minimap", comment: "Command description for toggling minimap"), comment: "Command title for toggling minimap"), title: "Toggle Minimap", id: "prefs.text_editing.toggle_minimap") {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(localized: "settings.text-editing.commands.toggle-gutter.title", defaultValue: String(localized: "settings.text-editing.commands.toggle-gutter.description", defaultValue: "Toggle Gutter", comment: "Command description for toggling gutter"), comment: "Command title for toggling gutter"), title: "Toggle Gutter", id: "prefs.text_editing.toggle_gutter") {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(localized: "settings.text-editing.commands.toggle-folding-ribbon.title", defaultValue: "Toggle Folding Ribbon", comment: "Command title for toggling editor folding ribbon"),
                title: String(localized: "settings.text-editing.commands.toggle-folding-ribbon.description", defaultValue: "Toggle Folding Ribbon", comment: "Command description for toggling editor folding ribbon"),
                id: "prefs.text_editing.toggle_folding_ribbon"
            ) {
                Settings[\.textEditing].showFoldingRibbon.toggle()
            }
        }

        struct IndentOption: Codable, Hashable {
            var indentType: IndentType
            /// Kept even when `indentType` is `.tab` to retain the user's
            /// settings when changing `indentType`.
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
            var color: Theme.Attributes = .init(color: "FFFFFF", bold: false, italic: false)

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
            static var `default`: InvisibleCharactersConfig = .init(
                enabled: false,
                showSpaces: true,
                showTabs: true,
                showLineEndings: true
            )

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
            static let `default`: WarningCharacters = .init(enabled: true, characters: [
                0x0003: String(localized: "settings.text-editing.warning-characters.end-of-text", defaultValue: "End of text", comment: "Label for end-of-text invisible warning character"),

                0x00A0: String(localized: "settings.text-editing.warning-characters.non-breaking-space", defaultValue: "Non-breaking space", comment: "Label for non-breaking space warning character"),
                0x202F: String(localized: "settings.text-editing.warning-characters.narrow-non-breaking-space", defaultValue: "Narrow non-breaking space", comment: "Label for narrow non-breaking space warning character"),
                0x200B: String(localized: "settings.text-editing.warning-characters.zero-width-space", defaultValue: "Zero-width space", comment: "Label for zero-width space warning character"),
                0x200C: String(localized: "settings.text-editing.warning-characters.zero-width-non-joiner", defaultValue: "Zero-width non-joiner", comment: "Label for zero-width non-joiner warning character"),
                0x2029: String(localized: "settings.text-editing.warning-characters.paragraph-separator", defaultValue: "Paragraph separator", comment: "Label for paragraph separator warning character"),

                0x2013: String(localized: "settings.text-editing.warning-characters.em-dash", defaultValue: "Em-dash", comment: "Label for em-dash warning character"),
                0x00AD: String(localized: "settings.text-editing.warning-characters.soft-hyphen", defaultValue: "Soft hyphen", comment: "Label for soft hyphen warning character"),

                0x2018: String(localized: "settings.text-editing.warning-characters.left-single-quote", defaultValue: "Left single quote", comment: "Label for left single quote warning character"),
                0x2019: String(localized: "settings.text-editing.warning-characters.right-single-quote", defaultValue: "Right single quote", comment: "Label for right single quote warning character"),
                0x201C: String(localized: "settings.text-editing.warning-characters.left-double-quote", defaultValue: "Left double quote", comment: "Label for left double quote warning character"),
                0x201D: String(localized: "settings.text-editing.warning-characters.right-double-quote", defaultValue: "Right double quote", comment: "Label for right double quote warning character"),

                0x037E: String(localized: "settings.text-editing.warning-characters.greek-question-mark", defaultValue: "Greek Question Mark", comment: "Label for greek question mark warning character"),
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
            size = try container.decodeIfPresent(Double.self, forKey: .size) ?? size
            name = try container.decodeIfPresent(String.self, forKey: .name) ?? name
            weight = try container.decodeIfPresent(NSFont.Weight.self, forKey: .weight) ?? weight
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
