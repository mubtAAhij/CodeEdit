//
//  String+escapedWhiteSpaces.swift
//  CodeEdit
//
//  Created by Paul Ebose on 2024/07/05.
//

import Foundation

extension String {
    /// Escapes the string so it's an always-valid directory
    func escapedDirectory() -> String {
        "\"\(self.escapedQuotes())\""
    }

    /// Returns a new string, replacing all occurrences of ` ` with `\ ` if they aren't already escaped.
    func escapedWhiteSpaces() -> String {
        escape(replacing: " ")
    }

    /// Returns a new string, replacing all occurrences of `"` with `\"` if they aren't already escaped.
    func escapedQuotes() -> String {
        escape(replacing: #String(localized: "string.escape.quote_char", defaultValue: "\"", comment: "Quote character to escape")#)
    }

    func escape(replacing: Character) -> String {
        var string = ""
        var lastChar: Character?

        for char in self {
            defer {
                lastChar = char
            }

            guard char == replacing else {
                string.append(char)
                continue
            }

            if let lastChar, lastChar == #String(localized: "string.escape.backslash", defaultValue: "\\", comment: "Backslash escape character")# {
                string.append(char)
                continue
            }

            string.append(#String(localized: "string.escape.backslash", defaultValue: "\\", comment: "Backslash escape character")#)
            string.append(char)
        }

        return string
    }
}
