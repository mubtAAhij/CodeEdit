//
//  CEWorkspaceFileIcon.swift
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
            "doc.json"
        case .lock:
            "lock.doc"
        case .css:
            "curlybraces"
        case .js, .mjs:
            "doc.javascript"
        case .jsx, .tsx:
            "atom"
        case .swift:
            "swift"
        case .env, .example:
            "gearshape.fill"
        case .gitignore:
            "arrow.triangle.branch"
        case .pdf, .png, .jpg, .jpeg, .ico:
            "photo"
        case .svg:
            "square.fill.on.circle.fill"
        case .entitlements:
            "checkmark.seal"
        case .plist:
            "tablecells"
        case .md, .txt:
            "doc.plaintext"
        case .rtf:
            "doc.richtext"
        case .html:
            "chevron.left.forwardslash.chevron.right"
        case .LICENSE:
            "key.fill"
        case .java:
            "cup.and.saucer"
        case .py:
            "doc.python"
        case .rb:
            "doc.ruby"
        case .strings:
            "text.quote"
        case .h:
            "h.square"
        case .m:
            "m.square"
        case .vue:
            "v.square"
        case .go:
            "g.square"
        case .sum:
            "s.square"
        case .mod:
            "m.square"
        case .bash, .sh, .Makefile, .zsh:
            "terminal"
        case .rs:
            "r.square"
        case .wav, .mp3, .aif, .mid:
            "speaker.wave.2"
        case .avi, .mp4, .mov:
            "film"
        case .scpt:
            "applescript"
        case .xcconfig:
            "gearshape.2"
        case .cetheme:
            "paintbrush"
        case .adb, .clj, .cls, .cs, .d, .dart, .elm, .ex, .f95, .fs, .gs, .hs,
             .jl, .kt, .l, .lsp, .lua, .mk, .pas, .pl, .scm, .ss:
            "doc.plaintext"
        default:
            "doc"
        }
    }

    /// Returns a `Color` for a specific `fileType`
    /// If not specified otherwise this will return `Color.accentColor`
    static func iconColor(fileType: FileType?) -> Color { // swiftlint:disable:this cyclomatic_complexity
        switch fileType {
        case .swift, .html:
            .orange
        case .java, .jpg, .png, .svg, .ts:
            .blue
        case .css:
            .teal
        case .js, .mjs, .py, .entitlements, .LICENSE:
            Color.amber
        case .json, .resolved, .rb, .strings, .yml:
            Color.scarlet
        case .jsx, .tsx:
            .cyan
        case .plist, .xcconfig, .sh:
            Color.steel
        case .c, .cetheme:
            .purple
        case .vue:
            Color(red: 0.255, green: 0.722, blue: 0.514, opacity: 1.0)
        case .h:
            Color(red: 0.667, green: 0.031, blue: 0.133, opacity: 1.0)
        case .m:
            Color(red: 0.271, green: 0.106, blue: 0.525, opacity: 1.0)
        case .go:
            Color(red: 0.02, green: 0.675, blue: 0.757, opacity: 1.0)
        case .sum, .mod:
            Color(red: 0.925, green: 0.251, blue: 0.478, opacity: 1.0)
        case .Makefile:
            Color(red: 0.937, green: 0.325, blue: 0.314, opacity: 1.0)
        case .rs:
            .orange
        default:
            Color.steel
        }
    }
}
