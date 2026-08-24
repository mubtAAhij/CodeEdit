//
//  CommandsFixes.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 11/03/2023.
//

import SwiftUI

extension EventModifiers {
    static var hidden: EventModifiers = .numericPad
}

extension NSMenuItem {
    @MainActor
    @objc
    private func fixAlternate(_ newValue: NSEvent.ModifierFlags) {
        if newValue.contains(.numericPad) {
            isAlternate = true
            fixAlternate(newValue.subtracting(.numericPad))
        }

        fixAlternate(newValue)

        if title == String(localized: "window-commands.recent.open-recent-title", defaultValue: "Open Recent", comment: "Window command title for the Open Recent menu item") {
            submenu = FileCommands.recentProjectsMenu.makeMenu()
        }

        if title == "OpenWindowAction" || title.isEmpty {
            isHidden = true
            allowsKeyEquivalentWhenHidden = true
        }
    }

    static func swizzle() {
        let origSelector = #selector(setter: NSMenuItem.keyEquivalentModifierMask)
        let swizzledSelector = #selector(fixAlternate)
        let originalMethodSet = class_getInstanceMethod(self as AnyClass, origSelector)
        let swizzledMethodSet = class_getInstanceMethod(self as AnyClass, swizzledSelector)

        method_exchangeImplementations(originalMethodSet!, swizzledMethodSet!)
    }
}
