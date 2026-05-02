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

        var localizedStringValue: String {
            switch self {
            case .appearance:
                return String(localized: "theme.coding.key.type", defaultValue: "type", comment: "JSON key for theme appearance type")
            case .metadataDescription:
                return String(localized: "theme.coding.key.description", defaultValue: "description", comment: "JSON key for theme description")
            default:
                return self.stringValue
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
                case String(localized: "theme.editor.key.text", defaultValue: "text", comment: "Editor theme key for text color"): return self.text
                case String(localized: "theme.editor.key.insertion.point", defaultValue: "insertionPoint", comment: "Editor theme key for insertion point color"): return self.insertionPoint
                case String(localized: "theme.editor.key.invisibles", defaultValue: "invisibles", comment: "Editor theme key for invisibles color"): return self.invisibles
                case String(localized: "theme.editor.key.background", defaultValue: "background", comment: "Editor theme key for background color"): return self.background
                case String(localized: "theme.editor.key.line.highlight", defaultValue: "lineHighlight", comment: "Editor theme key for line highlight color"): return self.lineHighlight
                case String(localized: "theme.editor.key.selection", defaultValue: "selection", comment: "Editor theme key for selection color"): return self.selection
                case String(localized: "theme.editor.key.keywords", defaultValue: "keywords", comment: "Editor theme key for keywords color"): return self.keywords
                case String(localized: "theme.editor.key.commands", defaultValue: "commands", comment: "Editor theme key for commands color"): return self.commands
                case String(localized: "theme.editor.key.types", defaultValue: "types", comment: "Editor theme key for types color"): return self.types
                case String(localized: "theme.editor.key.attributes", defaultValue: "attributes", comment: "Editor theme key for attributes color"): return self.attributes
                case String(localized: "theme.editor.key.variables", defaultValue: "variables", comment: "Editor theme key for variables color"): return self.variables
                case String(localized: "theme.editor.key.values", defaultValue: "values", comment: "Editor theme key for values color"): return self.values
                case String(localized: "theme.editor.key.numbers", defaultValue: "numbers", comment: "Editor theme key for numbers color"): return self.numbers
                case String(localized: "theme.editor.key.strings", defaultValue: "strings", comment: "Editor theme key for strings color"): return self.strings
                case String(localized: "theme.editor.key.characters", defaultValue: "characters", comment: "Editor theme key for characters color"): return self.characters
                case String(localized: "theme.editor.key.comments", defaultValue: "comments", comment: "Editor theme key for comments color"): return self.comments
                default: fatalError(String(localized: "theme.editor.invalid.key.error", defaultValue: "Invalid key", comment: "Error message for invalid theme editor key"))
                }
            }
            set {
                switch key {
                case String(localized: "theme.editor.key.text", defaultValue: "text", comment: "Editor theme key for text color"): self.text = newValue
                case String(localized: "theme.editor.key.insertion.point", defaultValue: "insertionPoint", comment: "Editor theme key for insertion point color"): self.insertionPoint = newValue
                case String(localized: "theme.editor.key.invisibles", defaultValue: "invisibles", comment: "Editor theme key for invisibles color"): self.invisibles = newValue
                case String(localized: "theme.editor.key.background", defaultValue: "background", comment: "Editor theme key for background color"): self.background = newValue
                case String(localized: "theme.editor.key.line.highlight", defaultValue: "lineHighlight", comment: "Editor theme key for line highlight color"): self.lineHighlight = newValue
                case String(localized: "theme.editor.key.selection", defaultValue: "selection", comment: "Editor theme key for selection color"): self.selection = newValue
                case String(localized: "theme.editor.key.keywords", defaultValue: "keywords", comment: "Editor theme key for keywords color"): self.keywords = newValue
                case String(localized: "theme.editor.key.commands", defaultValue: "commands", comment: "Editor theme key for commands color"): self.commands = newValue
                case String(localized: "theme.editor.key.types", defaultValue: "types", comment: "Editor theme key for types color"): self.types = newValue
                case String(localized: "theme.editor.key.attributes", defaultValue: "attributes", comment: "Editor theme key for attributes color"): self.attributes = newValue
                case String(localized: "theme.editor.key.variables", defaultValue: "variables", comment: "Editor theme key for variables color"): self.variables = newValue
                case String(localized: "theme.editor.key.values", defaultValue: "values", comment: "Editor theme key for values color"): self.values = newValue
                case String(localized: "theme.editor.key.numbers", defaultValue: "numbers", comment: "Editor theme key for numbers color"): self.numbers = newValue
                case String(localized: "theme.editor.key.strings", defaultValue: "strings", comment: "Editor theme key for strings color"): self.strings = newValue
                case String(localized: "theme.editor.key.characters", defaultValue: "characters", comment: "Editor theme key for characters color"): self.characters = newValue
                case String(localized: "theme.editor.key.comments", defaultValue: "comments", comment: "Editor theme key for comments color"): self.comments = newValue
                default: fatalError(String(localized: "theme.editor.invalid.key.error", defaultValue: "Invalid key", comment: "Error message for invalid theme editor key"))
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
                case String(localized: "theme.terminal.key.text", defaultValue: "text", comment: "Terminal theme key for text color"): return self.text
                case String(localized: "theme.terminal.key.bold.text", defaultValue: "boldText", comment: "Terminal theme key for bold text color"): return self.boldText
                case String(localized: "theme.terminal.key.cursor", defaultValue: "cursor", comment: "Terminal theme key for cursor color"): return self.cursor
                case String(localized: "theme.terminal.key.background", defaultValue: "background", comment: "Terminal theme key for background color"): return self.background
                case String(localized: "theme.terminal.key.selection", defaultValue: "selection", comment: "Terminal theme key for selection color"): return self.selection
                case String(localized: "theme.terminal.key.black", defaultValue: "black", comment: "Terminal theme key for black color"): return self.black
                case String(localized: "theme.terminal.key.red", defaultValue: "red", comment: "Terminal theme key for red color"): return self.red
                case String(localized: "theme.terminal.key.green", defaultValue: "green", comment: "Terminal theme key for green color"): return self.green
                case String(localized: "theme.terminal.key.yellow", defaultValue: "yellow", comment: "Terminal theme key for yellow color"): return self.yellow
                case String(localized: "theme.terminal.key.blue", defaultValue: "blue", comment: "Terminal theme key for blue color"): return self.blue
                case String(localized: "theme.terminal.key.magenta", defaultValue: "magenta", comment: "Terminal theme key for magenta color"): return self.magenta
                case String(localized: "theme.terminal.key.cyan", defaultValue: "cyan", comment: "Terminal theme key for cyan color"): return self.cyan
                case String(localized: "theme.terminal.key.white", defaultValue: "white", comment: "Terminal theme key for white color"): return self.white
                case String(localized: "theme.terminal.key.bright.black", defaultValue: "brightBlack", comment: "Terminal theme key for bright black color"): return self.brightBlack
                case String(localized: "theme.terminal.key.bright.red", defaultValue: "brightRed", comment: "Terminal theme key for bright red color"): return self.brightRed
                case String(localized: "theme.terminal.key.bright.green", defaultValue: "brightGreen", comment: "Terminal theme key for bright green color"): return self.brightGreen
                case String(localized: "theme.terminal.key.bright.yellow", defaultValue: "brightYellow", comment: "Terminal theme key for bright yellow color"): return self.brightYellow
                case String(localized: "theme.terminal.key.bright.blue", defaultValue: "brightBlue", comment: "Terminal theme key for bright blue color"): return self.brightBlue
                case String(localized: "theme.terminal.key.bright.magenta", defaultValue: "brightMagenta", comment: "Terminal theme key for bright magenta color"): return self.brightMagenta
                case String(localized: "theme.terminal.key.bright.cyan", defaultValue: "brightCyan", comment: "Terminal theme key for bright cyan color"): return self.brightCyan
                case String(localized: "theme.terminal.key.bright.white", defaultValue: "brightWhite", comment: "Terminal theme key for bright white color"): return self.brightWhite
                default: fatalError(String(localized: "theme.terminal.invalid.key.error", defaultValue: "Invalid key", comment: "Error message for invalid theme terminal key"))
                }
            }
            set {
                switch key {
                case String(localized: "theme.terminal.key.text", defaultValue: "text", comment: "Terminal theme key for text color"): self.text = newValue
                case String(localized: "theme.terminal.key.bold.text", defaultValue: "boldText", comment: "Terminal theme key for bold text color"): self.boldText = newValue
                case String(localized: "theme.terminal.key.cursor", defaultValue: "cursor", comment: "Terminal theme key for cursor color"): self.cursor = newValue
                case String(localized: "theme.terminal.key.background", defaultValue: "background", comment: "Terminal theme key for background color"): self.background = newValue
                case String(localized: "theme.terminal.key.selection", defaultValue: "selection", comment: "Terminal theme key for selection color"): self.selection = newValue
                case String(localized: "theme.terminal.key.black", defaultValue: "black", comment: "Terminal theme key for black color"): self.black = newValue
                case String(localized: "theme.terminal.key.red", defaultValue: "red", comment: "Terminal theme key for red color"): self.red = newValue
                case String(localized: "theme.terminal.key.green", defaultValue: "green", comment: "Terminal theme key for green color"): self.green = newValue
                case String(localized: "theme.terminal.key.yellow", defaultValue: "yellow", comment: "Terminal theme key for yellow color"): self.yellow = newValue
                case String(localized: "theme.terminal.key.blue", defaultValue: "blue", comment: "Terminal theme key for blue color"): self.blue = newValue
                case String(localized: "theme.terminal.key.magenta", defaultValue: "magenta", comment: "Terminal theme key for magenta color"): self.magenta = newValue
                case String(localized: "theme.terminal.key.cyan", defaultValue: "cyan", comment: "Terminal theme key for cyan color"): self.cyan = newValue
                case String(localized: "theme.terminal.key.white", defaultValue: "white", comment: "Terminal theme key for white color"): self.white = newValue
                case String(localized: "theme.terminal.key.bright.black", defaultValue: "brightBlack", comment: "Terminal theme key for bright black color"): self.brightBlack = newValue
                case String(localized: "theme.terminal.key.bright.red", defaultValue: "brightRed", comment: "Terminal theme key for bright red color"): self.brightRed = newValue
                case String(localized: "theme.terminal.key.bright.green", defaultValue: "brightGreen", comment: "Terminal theme key for bright green color"): self.brightGreen = newValue
                case String(localized: "theme.terminal.key.bright.yellow", defaultValue: "brightYellow", comment: "Terminal theme key for bright yellow color"): self.brightYellow = newValue
                case String(localized: "theme.terminal.key.bright.blue", defaultValue: "brightBlue", comment: "Terminal theme key for bright blue color"): self.brightBlue = newValue
                case String(localized: "theme.terminal.key.bright.magenta", defaultValue: "brightMagenta", comment: "Terminal theme key for bright magenta color"): self.brightMagenta = newValue
                case String(localized: "theme.terminal.key.bright.cyan", defaultValue: "brightCyan", comment: "Terminal theme key for bright cyan color"): self.brightCyan = newValue
                case String(localized: "theme.terminal.key.bright.white", defaultValue: "brightWhite", comment: "Terminal theme key for bright white color"): self.brightWhite = newValue
                default: fatalError(String(localized: "theme.terminal.invalid.key.error", defaultValue: "Invalid key", comment: "Error message for invalid theme terminal key"))
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
