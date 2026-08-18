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
                String(
                    localized: "settings.text-editing.prefer-indent-using.label",
                    defaultValue: "Prefer Indent Using",
                    comment: "Label for preferred indentation style setting"
                ),
                String(
                    localized: "settings.text-editing.tab-width.label",
                    defaultValue: "Tab Width",
                    comment: "Label for tab width setting"
                ),
                String(
                    localized: "settings.text-editing.wrap-lines-to-editor-width.toggle",
                    defaultValue: "Wrap lines to editor width",
                    comment: "Toggle label for wrapping lines to editor width"
                ),
                String(
                    localized: "settings.text-editing.editor-overscroll.label",
                    defaultValue: "Editor Overscroll",
                    comment: "Label for editor overscroll setting"
                ),
                String(
                    localized: "settings.text-editing.font.label",
                    defaultValue: "Font",
                    comment: "Label for editor font setting"
                ),
                String(
                    localized: "settings.text-editing.font-size.label",
                    defaultValue: "Font Size",
                    comment: "Label for editor font size setting"
                ),
                String(
                    localized: "settings.text-editing.font-weight.label",
                    defaultValue: "Font Weight",
                    comment: "Label for editor font weight setting"
                ),
                String(
                    localized: "settings.text-editing.line-height.label",
                    defaultValue: "Line Height",
                    comment: "Label for editor line height setting"
                ),
                String(
                    localized: "settings.text-editing.letter-spacing.label",
                    defaultValue: "Letter Spacing",
                    comment: "Label for editor letter spacing setting"
                ),
                String(
                    localized: "settings.text-editing.autocomplete-braces.toggle",
                    defaultValue: "Autocomplete braces",
                    comment: "Toggle label for automatic brace completion"
                ),
                String(
                    localized: "settings.text-editing.enable-type-over-completion.toggle",
                    defaultValue: "Enable type-over completion",
                    comment: "Toggle label for type-over completion behavior"
                ),
                String(
                    localized: "settings.text-editing.bracket-pair-emphasis.label",
                    defaultValue: "Bracket Pair Emphasis",
                    comment: "Label for bracket pair emphasis setting"
                ),
                String(
                    localized: "settings.text-editing.bracket-pair-highlight.toggle",
                    defaultValue: "Bracket Pair Highlight",
                    comment: "Toggle label for bracket pair highlighting"
                ),
                String(
                    localized: "settings.text-editing.show-gutter.toggle",
                    defaultValue: "Show Gutter",
                    comment: "Toggle label for showing editor gutter"
                ),
                String(
                    localized: "settings.text-editing.show-minimap.toggle",
                    defaultValue: "Show Minimap",
                    comment: "Toggle label for showing editor minimap"
                ),
                String(
                    localized: "settings.text-editing.reformat-at-column.label",
                    defaultValue: "Reformat at Column",
                    comment: "Label for reformat-at-column setting"
                ),
                String(
                    localized: "settings.text-editing.show-reformatting-guide.toggle",
                    defaultValue: "Show Reformatting Guide",
                    comment: "Toggle label for showing reformatting guide"
                ),
                String(
                    localized: "settings.text-editing.invisibles.label",
                    defaultValue: "Invisibles",
                    comment: "Label for invisibles settings section"
                ),
                String(
                    localized: "settings.text-editing.warning-characters.label",
                    defaultValue: "Warning Characters",
                    comment: "Label for warning characters settings section"
                )
            ]
            if #available(macOS 14.0, *) {
                keys.append(String(
                    localized: "settings.text-editing.system-cursor.toggle",
                    defaultValue: "System Cursor",
                    comment: "Toggle label for using system cursor style"
                ))
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
                name: String(
                    localized: "settings.text-editing.commands.toggle-type-over-completion.menu",
                    defaultValue: "Toggle Type-Over Completion",
                    comment: "Command title for toggling type-over completion"
                ),
                title: String(
                    localized: "settings.text-editing.commands.toggle-type-over-completion.help",
                    defaultValue: "Toggle Type-Over Completion",
                    comment: "Help text for the toggle type-over completion command"
                ),
                id: "prefs.text_editing.type_over_completion",
                command: {
                    Settings[\.textEditing].enableTypeOverCompletion.toggle()
                }
            )

            mgr.addCommand(
                name: String(
                    localized: "settings.text-editing.commands.toggle-autocomplete-braces.menu",
                    defaultValue: "Toggle Autocomplete Braces",
                    comment: "Command title for toggling autocomplete braces"
                ),
                title: String(
                    localized: "settings.text-editing.commands.toggle-autocomplete-braces.help",
                    defaultValue: "Toggle Autocomplete Braces",
                    comment: "Help text for the toggle autocomplete braces command"
                ),
                id: "prefs.text_editing.autocomplete_braces",
                command: {
                    Settings[\.textEditing].autocompleteBraces.toggle()
                }
            )

            mgr.addCommand(
                name: String(
                    localized: "settings.text-editing.commands.toggle-word-wrap.menu",
                    defaultValue: "Toggle Word Wrap",
                    comment: "Command title for toggling word wrap"
                ),
                title: String(
                    localized: "settings.text-editing.commands.toggle-word-wrap.help",
                    defaultValue: "Toggle Word Wrap",
                    comment: "Help text for the toggle word wrap command"
                ),
                id: "prefs.text_editing.wrap_lines_to_editor_width",
                command: {
                    Settings[\.textEditing].wrapLinesToEditorWidth.toggle()
                }
            )

            mgr.addCommand(name: String(
                localized: "settings.text-editing.commands.toggle-minimap.menu",
                defaultValue: "Toggle Minimap",
                comment: "Command title for toggling minimap visibility"
            ), title: String(
                localized: "settings.text-editing.commands.toggle-minimap.help",
                defaultValue: "Toggle Minimap",
                comment: "Help text for the toggle minimap command"
            ), id: "prefs.text_editing.toggle_minimap") {
                Settings[\.textEditing].showMinimap.toggle()
            }

            mgr.addCommand(name: String(
                localized: "settings.text-editing.commands.toggle-gutter.menu",
                defaultValue: "Toggle Gutter",
                comment: "Command title for toggling gutter visibility"
            ), title: String(
                localized: "settings.text-editing.commands.toggle-gutter.help",
                defaultValue: "Toggle Gutter",
                comment: "Help text for the toggle gutter command"
            ), id: "prefs.text_editing.toggle_gutter") {
                Settings[\.textEditing].showGutter.toggle()
            }

            mgr.addCommand(
                name: String(
                    localized: "settings.text-editing.commands.toggle-folding-ribbon.menu",
                    defaultValue: "Toggle Folding Ribbon",
                    comment: "Command title for toggling folding ribbon visibility"
                ),
                title: String(
                    localized: "settings.text-editing.commands.toggle-folding-ribbon.help",
                    defaultValue: "Toggle Folding Ribbon",
                    comment: "Help text for the toggle folding ribbon command"
                ),
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
                0x0003: String(
                    localized: "settings.text-editing.warning-characters.end-of-text.label",
                    defaultValue: "End of text",
                    comment: "Warning character name for end-of-text character"
                ),

                0x00A0: String(
                    localized: "settings.text-editing.warning-characters.non-breaking-space.label",
                    defaultValue: "Non-breaking space",
                    comment: "Warning character name for non-breaking space"
                ),
                0x202F: String(
                    localized: "settings.text-editing.warning-characters.narrow-non-breaking-space.label",
                    defaultValue: "Narrow non-breaking space",
                    comment: "Warning character name for narrow non-breaking space"
                ),
                0x200B: String(
                    localized: "settings.text-editing.warning-characters.zero-width-space.label",
                    defaultValue: "Zero-width space",
                    comment: "Warning character name for zero-width space"
                ),
                0x200C: String(
                    localized: "settings.text-editing.warning-characters.zero-width-non-joiner.label",
                    defaultValue: "Zero-width non-joiner",
                    comment: "Warning character name for zero-width non-joiner"
                ),
                0x2029: String(
                    localized: "settings.text-editing.warning-characters.paragraph-separator.label",
                    defaultValue: "Paragraph separator",
                    comment: "Warning character name for paragraph separator"
                ),

                0x2013: String(
                    localized: "settings.text-editing.warning-characters.em-dash.label",
                    defaultValue: "Em-dash",
                    comment: "Warning character name for em-dash"
                ),
                0x00AD: String(
                    localized: "settings.text-editing.warning-characters.soft-hyphen.label",
                    defaultValue: "Soft hyphen",
                    comment: "Warning character name for soft hyphen"
                ),

                0x2018: String(
                    localized: "settings.text-editing.warning-characters.left-single-quote.label",
                    defaultValue: "Left single quote",
                    comment: "Warning character label for left single quotation mark"
                ),
                0x2019: String(
                    localized: "settings.text-editing.warning-characters.right-single-quote.label",
                    defaultValue: "Right single quote",
                    comment: "Warning character label for right single quotation mark"
                ),
                0x201C: String(
                    localized: "settings.text-editing.warning-characters.left-double-quote.label",
                    defaultValue: "Left double quote",
                    comment: "Warning character label for left double quotation mark"
                ),
                0x201D: String(
                    localized: "settings.text-editing.warning-characters.right-double-quote.label",
                    defaultValue: "Right double quote",
                    comment: "Warning character label for right double quotation mark"
                ),

                0x037E: String(
                    localized: "settings.text-editing.warning-characters.greek-question-mark.label",
                    defaultValue: "Greek Question Mark",
                    comment: "Warning character label for Greek question mark"
                )
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
