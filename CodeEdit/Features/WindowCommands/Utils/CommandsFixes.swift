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
    fileprivate func fixAlternate(_ newValue: NSEvent.ModifierFlags) {
        if newValue.contains(.numericPad) {
            isAlternate = true
            fixAlternate(newValue.subtracting(.numericPad))
        }

        fixAlternate(newValue)

        if self.title == String(localized: "window-commands.fixes.open-recent.title", defaultValue: "Open Recent", comment: "Title of open recent submenu in command fixes") {
            self.submenu = FileCommands.recentProjectsMenu.makeMenu()
        }

        if self.title == String(localized: "window-commands.fixes.open-window-action.identifier", defaultValue: "OpenWindowAction", comment: "Identifier used for open window action command fix") || self.title.isEmpty {
            self.isHidden = true
            self.allowsKeyEquivalentWhenHidden = true
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
