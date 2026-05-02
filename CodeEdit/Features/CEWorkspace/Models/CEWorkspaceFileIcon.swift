//
//  FileIcon.swift
//  
//
//  Created by Nanashi Li on 2022/05/20.
//

import SwiftUI

// TODO: DOCS (Nanashi Li)
enum FileIcon {

    // swiftlint:disable identifier_name
    enum FileType: String {
        case adb
        case aif
        case avi
        case bash
        case c
        case cetheme
        case clj
        case cls
        case cs
        case css
        case d
        case dart
        case elm
        case entitlements
        case env
        case ex
        case example
        case f95
        case fs
        case gitignore
        case go
        case gs
        case h
        case hs
        case html
        case ico
        case java
        case jl
        case jpeg
        case jpg
        case js
        case json
        case jsx
        case kt
        case l
        case LICENSE
        case lock
        case lsp
        case lua
        case m
        case Makefile
        case md
        case mid
        case mjs
        case mk
        case mod
        case mov
        case mp3
        case mp4
        case pas
        case pdf
        case pl
        case plist
        case png
        case py
        case resolved
        case rb
        case rs
        case rtf
        case scm
        case scpt
        case sh
        case ss
        case strings
        case sum
        case svg
        case swift
        case ts
        case tsx
        case txt = "text"
        case vue
        case wav
        case xcconfig
        case yml
        case zsh
    }

    // swiftlint:enable identifier_name

    /// Returns a string describing a SFSymbol for files
    /// If not specified otherwise this will return `"doc"`
    static func fileIcon(fileType: FileType?) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        switch fileType {
        case .json, .yml, .resolved:
            return String(localized: "file.icon.doc.json", defaultValue: "doc.json", comment: "JSON document icon")
        case .lock:
            return String(localized: "file.icon.lock.doc", defaultValue: "lock.doc", comment: "Lock document icon")
        case .css:
            return String(localized: "file.icon.curlybraces", defaultValue: "curlybraces", comment: "CSS curlybraces icon")
        case .js, .mjs:
            return String(localized: "file.icon.doc.javascript", defaultValue: "doc.javascript", comment: "JavaScript document icon")
        case .jsx, .tsx:
            return String(localized: "file.icon.atom", defaultValue: "atom", comment: "Atom icon for React files")
        case .swift:
            return String(localized: "file.icon.swift", defaultValue: "swift", comment: "Swift icon")
        case .env, .example:
            return String(localized: "file.icon.gearshape.fill", defaultValue: "gearshape.fill", comment: "Gearshape fill icon for config files")
        case .gitignore:
            return String(localized: "file.icon.arrow.triangle.branch", defaultValue: "arrow.triangle.branch", comment: "Branch icon for gitignore")
        case .pdf, .png, .jpg, .jpeg, .ico:
            return String(localized: "file.icon.photo", defaultValue: "photo", comment: "Photo icon for image files")
        case .svg:
            return String(localized: "file.icon.square.fill.on.circle.fill", defaultValue: "square.fill.on.circle.fill", comment: "Square on circle icon for SVG")
        case .entitlements:
            return String(localized: "file.icon.checkmark.seal", defaultValue: "checkmark.seal", comment: "Checkmark seal icon for entitlements")
        case .plist:
            return String(localized: "file.icon.tablecells", defaultValue: "tablecells", comment: "Table cells icon for plist")
        case .md, .txt:
            return String(localized: "file.icon.doc.plaintext", defaultValue: "doc.plaintext", comment: "Plain text document icon")
        case .rtf:
            return String(localized: "file.icon.doc.richtext", defaultValue: "doc.richtext", comment: "Rich text document icon")
        case .html:
            return String(localized: "file.icon.chevron.left.forwardslash.chevron.right", defaultValue: "chevron.left.forwardslash.chevron.right", comment: "HTML tag icon")
        case .LICENSE:
            return String(localized: "file.icon.key.fill", defaultValue: "key.fill", comment: "Key icon for LICENSE")
        case .java:
            return String(localized: "file.icon.cup.and.saucer", defaultValue: "cup.and.saucer", comment: "Coffee cup icon for Java")
        case .py:
            return String(localized: "file.icon.doc.python", defaultValue: "doc.python", comment: "Python document icon")
        case .rb:
            return String(localized: "file.icon.doc.ruby", defaultValue: "doc.ruby", comment: "Ruby document icon")
        case .strings:
            return String(localized: "file.icon.text.quote", defaultValue: "text.quote", comment: "Text quote icon for strings files")
        case .h:
            return String(localized: "file.icon.h.square", defaultValue: "h.square", comment: "H square icon for header files")
        case .m:
            return String(localized: "file.icon.m.square", defaultValue: "m.square", comment: "M square icon for Objective-C files")
        case .vue:
            return String(localized: "file.icon.v.square", defaultValue: "v.square", comment: "V square icon for Vue files")
        case .go:
            return String(localized: "file.icon.g.square", defaultValue: "g.square", comment: "G square icon for Go files")
        case .sum:
            return String(localized: "file.icon.s.square", defaultValue: "s.square", comment: "S square icon for sum files")
        case .mod:
            return String(localized: "file.icon.m.square", defaultValue: "m.square", comment: "M square icon for mod files")
        case .bash, .sh, .Makefile, .zsh:
            return String(localized: "file.icon.terminal", defaultValue: "terminal", comment: "Terminal icon for shell scripts")
        case .rs:
            return String(localized: "file.icon.r.square", defaultValue: "r.square", comment: "R square icon for Rust files")
        case .wav, .mp3, .aif, .mid:
            return String(localized: "file.icon.speaker.wave.2", defaultValue: "speaker.wave.2", comment: "Speaker wave icon for audio files")
        case .avi, .mp4, .mov:
            return String(localized: "file.icon.film", defaultValue: "film", comment: "Film icon for video files")
        case .scpt:
            return String(localized: "file.icon.applescript", defaultValue: "applescript", comment: "AppleScript icon")
        case .xcconfig:
            return String(localized: "file.icon.gearshape.2", defaultValue: "gearshape.2", comment: "Gearshape 2 icon for xcconfig files")
        case .cetheme:
            return String(localized: "file.icon.paintbrush", defaultValue: "paintbrush", comment: "Paintbrush icon for theme files")
        case .adb, .clj, .cls, .cs, .d, .dart, .elm, .ex, .f95, .fs, .gs, .hs,
             .jl, .kt, .l, .lsp, .lua, .mk, .pas, .pl, .scm, .ss:
            return String(localized: "file.icon.doc.plaintext", defaultValue: "doc.plaintext", comment: "Plain text document icon")
        default:
            return String(localized: "file.icon.doc", defaultValue: "doc", comment: "Default document icon")
        }
    }

    /// Returns a `Color` for a specific `fileType`
    /// If not specified otherwise this will return `Color.accentColor`
    static func iconColor(fileType: FileType?) -> Color { // swiftlint:disable:this cyclomatic_complexity
        switch fileType {
        case .swift, .html:
            return .orange
        case .java, .jpg, .png, .svg, .ts:
            return .blue
        case .css:
            return .teal
        case .js, .mjs, .py, .entitlements, .LICENSE:
            return Color.amber
        case .json, .resolved, .rb, .strings, .yml:
            return Color.scarlet
        case .jsx, .tsx:
            return .cyan
        case .plist, .xcconfig, .sh:
            return Color.steel
        case .c, .cetheme:
            return .purple
        case .vue:
            return Color(red: 0.255, green: 0.722, blue: 0.514, opacity: 1.0)
        case .h:
            return Color(red: 0.667, green: 0.031, blue: 0.133, opacity: 1.0)
        case .m:
            return Color(red: 0.271, green: 0.106, blue: 0.525, opacity: 1.0)
        case .go:
            return Color(red: 0.02, green: 0.675, blue: 0.757, opacity: 1.0)
        case .sum, .mod:
            return Color(red: 0.925, green: 0.251, blue: 0.478, opacity: 1.0)
        case .Makefile:
            return Color(red: 0.937, green: 0.325, blue: 0.314, opacity: 1.0)
        case .rs:
            return .orange
        default:
            return Color.steel
        }
    }
}
