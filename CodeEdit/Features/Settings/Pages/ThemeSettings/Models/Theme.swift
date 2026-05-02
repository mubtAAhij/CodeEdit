//
//  Theme.swift
//  CodeEditModules/Settings
//
//  Created by Lukas Pistrol on 31.03.22.
//

import SwiftUI
import CodeEditSourceEditor

// swiftlint:disable file_length

/// # Theme
///
/// The model structure of themes for the editor & terminal emulator
struct Theme: Identifiable, Codable, Equatable, Hashable, Loopable {
    enum CodingKeys: String, CodingKey {
        case author, license, distributionURL, name, displayName, editor, terminal, version
        case appearance = "type"
        case metadataDescription = "description"

        var localizedKey: String {
            switch self {
            case .appearance:
                return String(localized: "theme.coding-key.type", defaultValue: "type", comment: "Theme appearance coding key")
            case .metadataDescription:
                return String(localized: "theme.coding-key.description", defaultValue: "description", comment: "Theme description coding key")
            default:
                return self.rawValue
            }
        }
    }

    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }

    /// The `id` of the theme
    var id: String { self.name }

    /// The `author` of the theme
    var author: String

    /// The `license` of the theme
    var license: String

    /// A short `description` of the theme
    var metadataDescription: String

    /// An URL for reference
    var distributionURL: String

    /// If the theme is bundled with CodeEdit or not
    var isBundled: Bool = false

    /// The URL for the theme file
    var fileURL: URL?

    /// The `unique name` of the theme
    var name: String

    /// The `display name` of the theme
    var displayName: String

    /// The `version` of the theme
    var version: String

    /// The ``ThemeType`` of the theme
    ///
    /// Appears as `"type"` in the `settings.json`
    var appearance: ThemeType

    /// Editor colors of the theme
    var editor: EditorColors

    /// Terminal colors of the theme
    var terminal: TerminalColors

    init(
        editor: EditorColors,
        terminal: TerminalColors,
        author: String,
        license: String,
        metadataDescription: String,
        distributionURL: String,
        isBundled: Bool,
        name: String,
        displayName: String,
        appearance: ThemeType,
        version: String
    ) {
        self.author = author
        self.license = license
        self.metadataDescription = metadataDescription
        self.distributionURL = distributionURL
        self.isBundled = isBundled
        self.name = name
        self.displayName = displayName
        self.appearance = appearance
        self.version = version
        self.editor = editor
        self.terminal = terminal
    }
}

extension Theme {
    /// The type of the theme
    /// - **dark**: this is a theme for dark system appearance
    /// - **light**: this is a theme for light system appearance
    enum ThemeType: String, Codable, Hashable {
        case dark
        case light
    }
}

// MARK: - Attributes
extension Theme {
    /// Attributes of a certain field
    ///
    /// As of now it only includes the colors `hex` string and
    /// an accessor for a `SwiftUI` `Color`.
    struct Attributes: Codable, Equatable, Hashable, Loopable {

        /// The 24-bit hex string of the color (e.g. #123456)
        var color: String
        var bold: Bool
        var italic: Bool

        init(color: String, bold: Bool = false, italic: Bool = false) {
            self.color = color
            self.bold = bold
            self.italic = italic
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.color = try container.decode(String.self, forKey: .color)
            self.bold = try container.decodeIfPresent(Bool.self, forKey: .bold) ?? false
            self.italic = try container.decodeIfPresent(Bool.self, forKey: .italic) ?? false
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(color, forKey: .color)

            if bold {
                try container.encode(bold, forKey: .bold)
            }

            if italic {
                try container.encode(italic, forKey: .italic)
            }
        }

        enum CodingKeys: String, CodingKey {
            case color
            case bold
            case italic
        }

        /// The `SwiftUI` of ``color``
        var swiftColor: Color {
            get {
                Color(hex: color)
            }
            set {
                self.color = newValue.hexString
            }
        }

        /// The `NSColor` of ``color``
        var nsColor: NSColor {
            get {
                NSColor(hex: color)
            }
            set {
                self.color = newValue.hexString
            }
        }
    }
}

extension Theme {
    /// The editor colors of the theme
    struct EditorColors: Codable, Hashable, Loopable {

        var editorTheme: EditorTheme {
            get {
                .init(
                    text: .init(color: text.nsColor),
                    insertionPoint: insertionPoint.nsColor,
                    invisibles: .init(color: invisibles.nsColor),
                    background: background.nsColor,
                    lineHighlight: lineHighlight.nsColor,
                    selection: selection.nsColor,
                    keywords: .init(color: keywords.nsColor),
                    commands: .init(color: commands.nsColor),
                    types: .init(color: types.nsColor),
                    attributes: .init(color: attributes.nsColor),
                    variables: .init(color: variables.nsColor),
                    values: .init(color: values.nsColor),
                    numbers: .init(color: numbers.nsColor),
                    strings: .init(color: strings.nsColor),
                    characters: .init(color: characters.nsColor),
                    comments: .init(color: comments.nsColor)
                )
            }
            set {
                self.text.nsColor = newValue.text.color
                self.insertionPoint.nsColor = newValue.insertionPoint
                self.invisibles.nsColor = newValue.invisibles.color
                self.background.nsColor = newValue.background
                self.lineHighlight.nsColor = newValue.lineHighlight
                self.selection.nsColor = newValue.selection
                self.keywords.nsColor = newValue.keywords.color
                self.commands.nsColor = newValue.commands.color
                self.types.nsColor = newValue.types.color
                self.attributes.nsColor = newValue.attributes.color
                self.variables.nsColor = newValue.variables.color
                self.values.nsColor = newValue.values.color
                self.numbers.nsColor = newValue.numbers.color
                self.strings.nsColor = newValue.strings.color
                self.characters.nsColor = newValue.characters.color
                self.comments.nsColor = newValue.comments.color
            }
        }

        var text: Attributes
        var insertionPoint: Attributes
        var invisibles: Attributes
        var background: Attributes
        var lineHighlight: Attributes
        var selection: Attributes
        var keywords: Attributes
        var commands: Attributes
        var types: Attributes
        var attributes: Attributes
        var variables: Attributes
        var values: Attributes
        var numbers: Attributes
        var strings: Attributes
        var characters: Attributes
        var comments: Attributes

        /// Allows to look up properties by their name
        ///
        /// **Example:**
        /// ```swift
        /// editor["text"]
        /// // equal to calling
        /// editor.text
        /// ```
        subscript(key: String) -> Attributes {
            get {
                switch key {
                case String(localized: "theme.editor-key.text", defaultValue: "text", comment: "Editor text color key"): return self.text
                case String(localized: "theme.editor-key.insertion-point", defaultValue: "insertionPoint", comment: "Editor insertion point color key"): return self.insertionPoint
                case String(localized: "theme.editor-key.invisibles", defaultValue: "invisibles", comment: "Editor invisibles color key"): return self.invisibles
                case String(localized: "theme.editor-key.background", defaultValue: "background", comment: "Editor background color key"): return self.background
                case String(localized: "theme.editor-key.line-highlight", defaultValue: "lineHighlight", comment: "Editor line highlight color key"): return self.lineHighlight
                case String(localized: "theme.editor-key.selection", defaultValue: "selection", comment: "Editor selection color key"): return self.selection
                case String(localized: "theme.editor-key.keywords", defaultValue: "keywords", comment: "Editor keywords color key"): return self.keywords
                case String(localized: "theme.editor-key.commands", defaultValue: "commands", comment: "Editor commands color key"): return self.commands
                case String(localized: "theme.editor-key.types", defaultValue: "types", comment: "Editor types color key"): return self.types
                case String(localized: "theme.editor-key.attributes", defaultValue: "attributes", comment: "Editor attributes color key"): return self.attributes
                case String(localized: "theme.editor-key.variables", defaultValue: "variables", comment: "Editor variables color key"): return self.variables
                case String(localized: "theme.editor-key.values", defaultValue: "values", comment: "Editor values color key"): return self.values
                case String(localized: "theme.editor-key.numbers", defaultValue: "numbers", comment: "Editor numbers color key"): return self.numbers
                case String(localized: "theme.editor-key.strings", defaultValue: "strings", comment: "Editor strings color key"): return self.strings
                case String(localized: "theme.editor-key.characters", defaultValue: "characters", comment: "Editor characters color key"): return self.characters
                case String(localized: "theme.editor-key.comments", defaultValue: "comments", comment: "Editor comments color key"): return self.comments
                default: fatalError(String(localized: "theme.editor-key.invalid", defaultValue: "Invalid key", comment: "Invalid editor color key error"))
                }
            }
            set {
                switch key {
                case String(localized: "theme.editor-key.text", defaultValue: "text", comment: "Editor text color key"): self.text = newValue
                case String(localized: "theme.editor-key.insertion-point", defaultValue: "insertionPoint", comment: "Editor insertion point color key"): self.insertionPoint = newValue
                case String(localized: "theme.editor-key.invisibles", defaultValue: "invisibles", comment: "Editor invisibles color key"): self.invisibles = newValue
                case String(localized: "theme.editor-key.background", defaultValue: "background", comment: "Editor background color key"): self.background = newValue
                case String(localized: "theme.editor-key.line-highlight", defaultValue: "lineHighlight", comment: "Editor line highlight color key"): self.lineHighlight = newValue
                case String(localized: "theme.editor-key.selection", defaultValue: "selection", comment: "Editor selection color key"): self.selection = newValue
                case String(localized: "theme.editor-key.keywords", defaultValue: "keywords", comment: "Editor keywords color key"): self.keywords = newValue
                case String(localized: "theme.editor-key.commands", defaultValue: "commands", comment: "Editor commands color key"): self.commands = newValue
                case String(localized: "theme.editor-key.types", defaultValue: "types", comment: "Editor types color key"): self.types = newValue
                case String(localized: "theme.editor-key.attributes", defaultValue: "attributes", comment: "Editor attributes color key"): self.attributes = newValue
                case String(localized: "theme.editor-key.variables", defaultValue: "variables", comment: "Editor variables color key"): self.variables = newValue
                case String(localized: "theme.editor-key.values", defaultValue: "values", comment: "Editor values color key"): self.values = newValue
                case String(localized: "theme.editor-key.numbers", defaultValue: "numbers", comment: "Editor numbers color key"): self.numbers = newValue
                case String(localized: "theme.editor-key.strings", defaultValue: "strings", comment: "Editor strings color key"): self.strings = newValue
                case String(localized: "theme.editor-key.characters", defaultValue: "characters", comment: "Editor characters color key"): self.characters = newValue
                case String(localized: "theme.editor-key.comments", defaultValue: "comments", comment: "Editor comments color key"): self.comments = newValue
                default: fatalError(String(localized: "theme.editor-key.invalid", defaultValue: "Invalid key", comment: "Invalid editor color key error"))
                }
            }
        }

        init(
            text: Attributes,
            insertionPoint: Attributes,
            invisibles: Attributes,
            background: Attributes,
            lineHighlight: Attributes,
            selection: Attributes,
            keywords: Attributes,
            commands: Attributes,
            types: Attributes,
            attributes: Attributes,
            variables: Attributes,
            values: Attributes,
            numbers: Attributes,
            strings: Attributes,
            characters: Attributes,
            comments: Attributes
        ) {
            self.text = text
            self.insertionPoint = insertionPoint
            self.invisibles = invisibles
            self.background = background
            self.lineHighlight = lineHighlight
            self.selection = selection
            self.keywords = keywords
            self.commands = commands
            self.types = types
            self.attributes = attributes
            self.variables = variables
            self.values = values
            self.numbers = numbers
            self.strings = strings
            self.characters = characters
            self.comments = comments
        }
    }
}

extension Theme {
    /// The terminal emulator colors of the theme
    struct TerminalColors: Codable, Hashable, Loopable {
        var text: Attributes
        var boldText: Attributes
        var cursor: Attributes
        var background: Attributes
        var selection: Attributes
        var black: Attributes
        var red: Attributes
        var green: Attributes
        var yellow: Attributes
        var blue: Attributes
        var magenta: Attributes
        var cyan: Attributes
        var white: Attributes
        var brightBlack: Attributes
        var brightRed: Attributes
        var brightGreen: Attributes
        var brightYellow: Attributes
        var brightBlue: Attributes
        var brightMagenta: Attributes
        var brightCyan: Attributes
        var brightWhite: Attributes

        var ansiColors: [String] {
            [
                black.color,
                red.color,
                green.color,
                yellow.color,
                blue.color,
                magenta.color,
                cyan.color,
                white.color,
                brightBlack.color,
                brightRed.color,
                brightGreen.color,
                brightYellow.color,
                brightBlue.color,
                brightMagenta.color,
                brightCyan.color,
                brightWhite.color,
            ]
        }

        /// Allows to look up properties by their name
        ///
        /// **Example:**
        /// ```swift
        /// terminal["text"]
        /// // equal to calling
        /// terminal.text
        /// ```
        subscript(key: String) -> Attributes {
            get {
                switch key {
                case String(localized: "theme.terminal-key.text", defaultValue: "text", comment: "Terminal text color key"): return self.text
                case String(localized: "theme.terminal-key.bold-text", defaultValue: "boldText", comment: "Terminal bold text color key"): return self.boldText
                case String(localized: "theme.terminal-key.cursor", defaultValue: "cursor", comment: "Terminal cursor color key"): return self.cursor
                case String(localized: "theme.terminal-key.background", defaultValue: "background", comment: "Terminal background color key"): return self.background
                case String(localized: "theme.terminal-key.selection", defaultValue: "selection", comment: "Terminal selection color key"): return self.selection
                case String(localized: "theme.terminal-key.black", defaultValue: "black", comment: "Terminal black color key"): return self.black
                case String(localized: "theme.terminal-key.red", defaultValue: "red", comment: "Terminal red color key"): return self.red
                case String(localized: "theme.terminal-key.green", defaultValue: "green", comment: "Terminal green color key"): return self.green
                case String(localized: "theme.terminal-key.yellow", defaultValue: "yellow", comment: "Terminal yellow color key"): return self.yellow
                case String(localized: "theme.terminal-key.blue", defaultValue: "blue", comment: "Terminal blue color key"): return self.blue
                case String(localized: "theme.terminal-key.magenta", defaultValue: "magenta", comment: "Terminal magenta color key"): return self.magenta
                case String(localized: "theme.terminal-key.cyan", defaultValue: "cyan", comment: "Terminal cyan color key"): return self.cyan
                case String(localized: "theme.terminal-key.white", defaultValue: "white", comment: "Terminal white color key"): return self.white
                case String(localized: "theme.terminal-key.bright-black", defaultValue: "brightBlack", comment: "Terminal bright black color key"): return self.brightBlack
                case String(localized: "theme.terminal-key.bright-red", defaultValue: "brightRed", comment: "Terminal bright red color key"): return self.brightRed
                case String(localized: "theme.terminal-key.bright-green", defaultValue: "brightGreen", comment: "Terminal bright green color key"): return self.brightGreen
                case String(localized: "theme.terminal-key.bright-yellow", defaultValue: "brightYellow", comment: "Terminal bright yellow color key"): return self.brightYellow
                case String(localized: "theme.terminal-key.bright-blue", defaultValue: "brightBlue", comment: "Terminal bright blue color key"): return self.brightBlue
                case String(localized: "theme.terminal-key.bright-magenta", defaultValue: "brightMagenta", comment: "Terminal bright magenta color key"): return self.brightMagenta
                case String(localized: "theme.terminal-key.bright-cyan", defaultValue: "brightCyan", comment: "Terminal bright cyan color key"): return self.brightCyan
                case String(localized: "theme.terminal-key.bright-white", defaultValue: "brightWhite", comment: "Terminal bright white color key"): return self.brightWhite
                default: fatalError(String(localized: "theme.terminal-key.invalid", defaultValue: "Invalid key", comment: "Error message for invalid terminal color key"))
                }
            }
            set {
                switch key {
                case String(localized: "theme.terminal-key.text", defaultValue: "text", comment: "Terminal text color key"): self.text = newValue
                case String(localized: "theme.terminal-key.bold-text", defaultValue: "boldText", comment: "Terminal bold text color key"): self.boldText = newValue
                case String(localized: "theme.terminal-key.cursor", defaultValue: "cursor", comment: "Terminal cursor color key"): self.cursor = newValue
                case String(localized: "theme.terminal-key.background", defaultValue: "background", comment: "Terminal background color key"): self.background = newValue
                case String(localized: "theme.terminal-key.selection", defaultValue: "selection", comment: "Terminal selection color key"): self.selection = newValue
                case String(localized: "theme.terminal-key.black", defaultValue: "black", comment: "Terminal black color key"): self.black = newValue
                case String(localized: "theme.terminal-key.red", defaultValue: "red", comment: "Terminal red color key"): self.red = newValue
                case String(localized: "theme.terminal-key.green", defaultValue: "green", comment: "Terminal green color key"): self.green = newValue
                case String(localized: "theme.terminal-key.yellow", defaultValue: "yellow", comment: "Terminal yellow color key"): self.yellow = newValue
                case String(localized: "theme.terminal-key.blue", defaultValue: "blue", comment: "Terminal blue color key"): self.blue = newValue
                case String(localized: "theme.terminal-key.magenta", defaultValue: "magenta", comment: "Terminal magenta color key"): self.magenta = newValue
                case String(localized: "theme.terminal-key.cyan", defaultValue: "cyan", comment: "Terminal cyan color key"): self.cyan = newValue
                case String(localized: "theme.terminal-key.white", defaultValue: "white", comment: "Terminal white color key"): self.white = newValue
                case String(localized: "theme.terminal-key.bright-black", defaultValue: "brightBlack", comment: "Terminal bright black color key"): self.brightBlack = newValue
                case String(localized: "theme.terminal-key.bright-red", defaultValue: "brightRed", comment: "Terminal bright red color key"): self.brightRed = newValue
                case String(localized: "theme.terminal-key.bright-green", defaultValue: "brightGreen", comment: "Terminal bright green color key"): self.brightGreen = newValue
                case String(localized: "theme.terminal-key.bright-yellow", defaultValue: "brightYellow", comment: "Terminal bright yellow color key"): self.brightYellow = newValue
                case String(localized: "theme.terminal-key.bright-blue", defaultValue: "brightBlue", comment: "Terminal bright blue color key"): self.brightBlue = newValue
                case String(localized: "theme.terminal-key.bright-magenta", defaultValue: "brightMagenta", comment: "Terminal bright magenta color key"): self.brightMagenta = newValue
                case String(localized: "theme.terminal-key.bright-cyan", defaultValue: "brightCyan", comment: "Terminal bright cyan color key"): self.brightCyan = newValue
                case String(localized: "theme.terminal-key.bright-white", defaultValue: "brightWhite", comment: "Terminal bright white color key"): self.brightWhite = newValue
                default: fatalError(String(localized: "theme.terminal-key.invalid", defaultValue: "Invalid key", comment: "Error message for invalid terminal color key"))
                }
            }
        }

        init(
            text: Attributes,
            boldText: Attributes,
            cursor: Attributes,
            background: Attributes,
            selection: Attributes,
            black: Attributes,
            red: Attributes,
            green: Attributes,
            yellow: Attributes,
            blue: Attributes,
            magenta: Attributes,
            cyan: Attributes,
            white: Attributes,
            brightBlack: Attributes,
            brightRed: Attributes,
            brightGreen: Attributes,
            brightYellow: Attributes,
            brightBlue: Attributes,
            brightMagenta: Attributes,
            brightCyan: Attributes,
            brightWhite: Attributes
        ) {
            self.text = text
            self.boldText = boldText
            self.cursor = cursor
            self.background = background
            self.selection = selection
            self.black = black
            self.red = red
            self.green = green
            self.yellow = yellow
            self.blue = blue
            self.magenta = magenta
            self.cyan = cyan
            self.white = white
            self.brightBlack = brightBlack
            self.brightRed = brightRed
            self.brightGreen = brightGreen
            self.brightYellow = brightYellow
            self.brightBlue = brightBlue
            self.brightMagenta = brightMagenta
            self.brightCyan = brightCyan
            self.brightWhite = brightWhite
        }
    }
}
