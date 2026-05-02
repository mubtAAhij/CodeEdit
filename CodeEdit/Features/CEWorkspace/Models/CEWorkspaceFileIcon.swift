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
            return String(localized: "file-icon.symbol.doc-json", defaultValue: "doc.json", comment: "SF Symbol for JSON file icon")
        case .lock:
            return String(localized: "file-icon.symbol.lock-doc", defaultValue: "lock.doc", comment: "SF Symbol for lock file icon")
        case .css:
            return String(localized: "file-icon.symbol.curlybraces", defaultValue: "curlybraces", comment: "SF Symbol for CSS file icon")
        case .js, .mjs:
            return String(localized: "file-icon.symbol.doc-javascript", defaultValue: "doc.javascript", comment: "SF Symbol for JavaScript file icon")
        case .jsx, .tsx:
            return String(localized: "file-icon.symbol.atom", defaultValue: "atom", comment: "SF Symbol for JSX/TSX file icon")
        case .swift:
            return String(localized: "file-icon.symbol.swift", defaultValue: "swift", comment: "SF Symbol for Swift file icon")
        case .env, .example:
            return String(localized: "file-icon.symbol.gearshape-fill", defaultValue: "gearshape.fill", comment: "SF Symbol for environment file icon")
        case .gitignore:
            return String(localized: "file-icon.symbol.arrow-triangle-branch", defaultValue: "arrow.triangle.branch", comment: "SF Symbol for gitignore file icon")
        case .pdf, .png, .jpg, .jpeg, .ico:
            return String(localized: "file-icon.symbol.photo", defaultValue: "photo", comment: "SF Symbol for image/PDF file icon")
        case .svg:
            return String(localized: "file-icon.symbol.square-fill-on-circle-fill", defaultValue: "square.fill.on.circle.fill", comment: "SF Symbol for SVG file icon")
        case .entitlements:
            return String(localized: "file-icon.symbol.checkmark-seal", defaultValue: "checkmark.seal", comment: "SF Symbol for entitlements file icon")
        case .plist:
            return String(localized: "file-icon.symbol.tablecells", defaultValue: "tablecells", comment: "SF Symbol for plist file icon")
        case .md, .txt:
            return String(localized: "file-icon.symbol.doc-plaintext", defaultValue: "doc.plaintext", comment: "SF Symbol for plain text file icon")
        case .rtf:
            return String(localized: "file-icon.symbol.doc-richtext", defaultValue: "doc.richtext", comment: "SF Symbol for rich text file icon")
        case .html:
            return String(localized: "file-icon.symbol.chevron-left-forwardslash-chevron-right", defaultValue: "chevron.left.forwardslash.chevron.right", comment: "SF Symbol for HTML file icon")
        case .LICENSE:
            return String(localized: "file-icon.symbol.key-fill", defaultValue: "key.fill", comment: "SF Symbol for LICENSE file icon")
        case .java:
            return String(localized: "file-icon.symbol.cup-and-saucer", defaultValue: "cup.and.saucer", comment: "SF Symbol for Java file icon")
        case .py:
            return String(localized: "file-icon.symbol.doc-python", defaultValue: "doc.python", comment: "SF Symbol for Python file icon")
        case .rb:
            return String(localized: "file-icon.symbol.doc-ruby", defaultValue: "doc.ruby", comment: "SF Symbol for Ruby file icon")
        case .strings:
            return String(localized: "file-icon.symbol.text-quote", defaultValue: "text.quote", comment: "SF Symbol for strings file icon")
        case .h:
            return String(localized: "file-icon.symbol.h-square", defaultValue: "h.square", comment: "SF Symbol for header file icon")
        case .m:
            return String(localized: "file-icon.symbol.m-square", defaultValue: "m.square", comment: "SF Symbol for Objective-C file icon")
        case .vue:
            return String(localized: "file-icon.symbol.v-square", defaultValue: "v.square", comment: "SF Symbol for Vue file icon")
        case .go:
            return String(localized: "file-icon.symbol.g-square", defaultValue: "g.square", comment: "SF Symbol for Go file icon")
        case .sum:
            return String(localized: "file-icon.symbol.s-square", defaultValue: "s.square", comment: "SF Symbol for sum file icon")
        case .mod:
            return String(localized: "file-icon.symbol.m-square-mod", defaultValue: "m.square", comment: "SF Symbol for mod file icon")
        case .bash, .sh, .Makefile, .zsh:
            return String(localized: "file-icon.symbol.terminal", defaultValue: "terminal", comment: "SF Symbol for shell script file icon")
        case .rs:
            return String(localized: "file-icon.symbol.r-square", defaultValue: "r.square", comment: "SF Symbol for Rust file icon")
        case .wav, .mp3, .aif, .mid:
            return String(localized: "file-icon.symbol.speaker-wave-2", defaultValue: "speaker.wave.2", comment: "SF Symbol for audio file icon")
        case .avi, .mp4, .mov:
            return String(localized: "file-icon.symbol.film", defaultValue: "film", comment: "SF Symbol for video file icon")
        case .scpt:
            return String(localized: "file-icon.symbol.applescript", defaultValue: "applescript", comment: "SF Symbol for AppleScript file icon")
        case .xcconfig:
            return String(localized: "file-icon.symbol.gearshape-2", defaultValue: "gearshape.2", comment: "SF Symbol for xcconfig file icon")
        case .cetheme:
            return String(localized: "file-icon.symbol.paintbrush", defaultValue: "paintbrush", comment: "SF Symbol for theme file icon")
        case .adb, .clj, .cls, .cs, .d, .dart, .elm, .ex, .f95, .fs, .gs, .hs,
             .jl, .kt, .l, .lsp, .lua, .mk, .pas, .pl, .scm, .ss:
            return String(localized: "file-icon.symbol.doc-plaintext-generic", defaultValue: "doc.plaintext", comment: "SF Symbol for generic code file icon")
        default:
            return String(localized: "file-icon.symbol.doc", defaultValue: "doc", comment: "SF Symbol for default file icon")
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
