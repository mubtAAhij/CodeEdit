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
        case txt = String(localized: "should_not_localize", defaultValue: "text", comment: "")
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
            return String(localized: "should_not_localize", defaultValue: "doc.json", comment: "")
        case .lock:
            return String(localized: "should_not_localize", defaultValue: "lock.doc", comment: "")
        case .css:
            return String(localized: "should_not_localize", defaultValue: "curlybraces", comment: "")
        case .js, .mjs:
            return String(localized: "should_not_localize", defaultValue: "doc.javascript", comment: "")
        case .jsx, .tsx:
            return String(localized: "should_not_localize", defaultValue: "atom", comment: "")
        case .swift:
            return String(localized: "should_not_localize", defaultValue: "swift", comment: "")
        case .env, .example:
            return String(localized: "should_not_localize", defaultValue: "gearshape.fill", comment: "")
        case .gitignore:
            return String(localized: "should_not_localize", defaultValue: "arrow.triangle.branch", comment: "")
        case .pdf, .png, .jpg, .jpeg, .ico:
            return String(localized: "should_not_localize", defaultValue: "photo", comment: "")
        case .svg:
            return String(localized: "should_not_localize", defaultValue: "square.fill.on.circle.fill", comment: "")
        case .entitlements:
            return String(localized: "should_not_localize", defaultValue: "checkmark.seal", comment: "")
        case .plist:
            return String(localized: "should_not_localize", defaultValue: "tablecells", comment: "")
        case .md, .txt:
            return String(localized: "should_not_localize", defaultValue: "doc.plaintext", comment: "")
        case .rtf:
            return String(localized: "should_not_localize", defaultValue: "doc.richtext", comment: "")
        case .html:
            return String(localized: "should_not_localize", defaultValue: "chevron.left.forwardslash.chevron.right", comment: "")
        case .LICENSE:
            return String(localized: "should_not_localize", defaultValue: "key.fill", comment: "")
        case .java:
            return String(localized: "should_not_localize", defaultValue: "cup.and.saucer", comment: "")
        case .py:
            return String(localized: "should_not_localize", defaultValue: "doc.python", comment: "")
        case .rb:
            return String(localized: "should_not_localize", defaultValue: "doc.ruby", comment: "")
        case .strings:
            return String(localized: "should_not_localize", defaultValue: "text.quote", comment: "")
        case .h:
            return String(localized: "should_not_localize", defaultValue: "h.square", comment: "")
        case .m:
            return String(localized: "should_not_localize", defaultValue: "m.square", comment: "")
        case .vue:
            return String(localized: "should_not_localize", defaultValue: "v.square", comment: "")
        case .go:
            return String(localized: "should_not_localize", defaultValue: "g.square", comment: "")
        case .sum:
            return String(localized: "should_not_localize", defaultValue: "s.square", comment: "")
        case .mod:
            return String(localized: "should_not_localize", defaultValue: "m.square", comment: "")
        case .bash, .sh, .Makefile, .zsh:
            return String(localized: "should_not_localize", defaultValue: "terminal", comment: "")
        case .rs:
            return String(localized: "should_not_localize", defaultValue: "r.square", comment: "")
        case .wav, .mp3, .aif, .mid:
            return String(localized: "should_not_localize", defaultValue: "speaker.wave.2", comment: "")
        case .avi, .mp4, .mov:
            return String(localized: "should_not_localize", defaultValue: "film", comment: "")
        case .scpt:
            return String(localized: "should_not_localize", defaultValue: "applescript", comment: "")
        case .xcconfig:
            return String(localized: "should_not_localize", defaultValue: "gearshape.2", comment: "")
        case .cetheme:
            return String(localized: "should_not_localize", defaultValue: "paintbrush", comment: "")
        case .adb, .clj, .cls, .cs, .d, .dart, .elm, .ex, .f95, .fs, .gs, .hs,
             .jl, .kt, .l, .lsp, .lua, .mk, .pas, .pl, .scm, .ss:
            return String(localized: "should_not_localize", defaultValue: "doc.plaintext", comment: "")
        default:
            return String(localized: "should_not_localize", defaultValue: "doc", comment: "")
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
