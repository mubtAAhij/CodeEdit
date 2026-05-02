//
//  KeybindingManager.swift
//
//  Created by Alex on 09.05.2022.
//

import Foundation
import SwiftUI

final class KeybindingManager {
    /// Array which contains all available keyboard shortcuts
    var keyboardShortcuts = [String: KeyboardShortcutWrapper]()

    private init() {
        loadKeybindings()
    }

    /// Static method to access singleton
    static let shared: KeybindingManager = .init()

    // We need this fallback shortcut because optional shortcuts available only from 12.3, while we have target of 12.0x
    var fallbackShortcut = KeyboardShortcutWrapper(
        name: String(localized: "keybinding.fallback.name", defaultValue: "?", comment: "Keybinding fallback name"),
        description: String(localized: "keybinding.fallback.description", defaultValue: "Test", comment: "Keybinding fallback description"),
        context: String(localized: "keybinding.fallback.context", defaultValue: "Fallback", comment: "Keybinding fallback context"),
        keybinding: String(localized: "keybinding.fallback.key", defaultValue: "?", comment: "Keybinding fallback key"),
        modifier: String(localized: "keybinding.modifier.shift", defaultValue: "shift", comment: "Keybinding shift modifier"),
        id: String(localized: "keybinding.fallback.id", defaultValue: "fallback", comment: "Keybinding fallback identifier")
    )

    /// Adds new shortcut
    func addNewShortcut(shortcut: KeyboardShortcutWrapper, name: String) {
        keyboardShortcuts[name] = shortcut
    }

    private func loadKeybindings() {

        let bindingsURL = Bundle.main.url(forResource: String(localized: "keybinding.default.filename", defaultValue: "default_keybindings.json", comment: "Keybinding default filename"), withExtension: nil)
        if let json = try? Data(contentsOf: bindingsURL!) {
            do {
                let prefs = try JSONDecoder().decode([KeyboardShortcutWrapper].self, from: json)
                for pref in prefs {
                    addNewShortcut(shortcut: pref, name: pref.id)
                }
                } catch {
                    print(String(format: String(localized: "keybinding.load.error", defaultValue: "error:%@", comment: "Keybinding load error message"), String(describing: error)))
                }
        }
        return
    }

    /// Get shortcut by name
    /// - Parameter name: shortcut name
    /// - Returns: KeyboardShortcutWrapper
    func named(with name: String) -> KeyboardShortcutWrapper {
        let foundElement = keyboardShortcuts[name]
        return foundElement != nil ? foundElement! : fallbackShortcut
    }

}

/// Wrapper for KeyboardShortcut. It contains name, keybindings.
struct KeyboardShortcutWrapper: Codable, Hashable {
    var keyboardShortcut: KeyboardShortcut {
        return KeyboardShortcut.init(.init(Character(keybinding)), modifiers: parsedModifier)
    }

    var parsedModifier: EventModifiers {
        switch modifier {
        case String(localized: "keybinding.modifier.command", defaultValue: "command", comment: "Keybinding command modifier"):
            return EventModifiers.command
        case String(localized: "keybinding.modifier.shift", defaultValue: "shift", comment: "Keybinding shift modifier"):
            return EventModifiers.shift
        case String(localized: "keybinding.modifier.option", defaultValue: "option", comment: "Keybinding option modifier"):
            return EventModifiers.option
        case String(localized: "keybinding.modifier.control", defaultValue: "control", comment: "Keybinding control modifier"):
            return EventModifiers.control
        default:
            return EventModifiers.command
        }
    }
    var name: String
    var description: String
    var context: String
    var keybinding: String
    var modifier: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case context
        case keybinding
        case modifier
        case id
    }

    init(name: String, description: String, context: String, keybinding: String, modifier: String, id: String) {
        self.name = name
        self.description = description
        self.context = context
        self.keybinding = keybinding
        self.modifier = modifier
        self.id = id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        context = try container.decode(String.self, forKey: .context)
        keybinding = try container.decode(String.self, forKey: .keybinding)
        modifier = try container.decode(String.self, forKey: .modifier)
        id = try container.decode(String.self, forKey: .id)
    }
}
