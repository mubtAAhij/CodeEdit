//
//  SettingsPage.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 30/03/23.
//

import Foundation
import SwiftUI

/// A struct for a settings page
struct SettingsPage: Hashable, Equatable, Identifiable {
    /// A struct for a sidebar icon, with a base color and SF Symbol
    enum IconResource: Equatable, Hashable {
        case system(_ name: String)
        case symbol(_ name: String)
        case asset(_ name: String)
    }

    /// An enum of all the settings pages
    enum Name: String {
        case general = "General"
        case accounts = "Accounts"
        case behavior = "Behaviors"
        case navigation = "Navigation"
        case theme = "Themes"
        case textEditing = "Text Editing"
        case terminal = "Terminal"
        case search
        case keybindings = "Key Bindings"
        case sourceControl
        case components
        case location
        case advanced
        case languageServers = "Language Servers"
        case developer
        
        var rawValue: String {
            switch self {
            case .general: return "General"
            case .accounts: return "Accounts"
            case .behavior: return "Behaviors"
            case .navigation: return "Navigation"
            case .theme: return "Themes"
            case .textEditing: return "Text Editing"
            case .terminal: return "Terminal"
            case .search: return String(localized: "Search", comment: "Settings page name")
            case .keybindings: return "Key Bindings"
            case .sourceControl: return String(localized: "Source Control", comment: "Settings page name")
            case .components: return String(localized: "Components", comment: "Settings page name")
            case .location: return String(localized: "Locations", comment: "Settings page name")
            case .advanced: return String(localized: "Advanced", comment: "Settings page name")
            case .languageServers: return "Language Servers"
            case .developer: return String(localized: "Developer", comment: "Settings page name")
            }
        }
        
        init?(rawValue: String) {
            switch rawValue {
            case "General": self = .general
            case "Accounts": self = .accounts
            case "Behaviors": self = .behavior
            case "Navigation": self = .navigation
            case "Themes": self = .theme
            case "Text Editing": self = .textEditing
            case "Terminal": self = .terminal
            case String(localized: "Search", comment: "Settings page name"): self = .search
            case "Key Bindings": self = .keybindings
            case String(localized: "Source Control", comment: "Settings page name"): self = .sourceControl
            case String(localized: "Components", comment: "Settings page name"): self = .components
            case String(localized: "Locations", comment: "Settings page name"): self = .location
            case String(localized: "Advanced", comment: "Settings page name"): self = .advanced
            case "Language Servers": self = .languageServers
            case String(localized: "Developer", comment: "Settings page name"): self = .developer
            default: return nil
            }
        }
    }

    let id: UUID = UUID()

    let name: Name
    let baseColor: Color?
    let isSetting: Bool
    let settingName: String
    var nameString: LocalizedStringKey {
        LocalizedStringKey(name.rawValue)
    }
    let icon: IconResource?

    /// Default initializer
    init(
        _ name: Name,
        baseColor: Color? = nil,
        icon: IconResource? = nil,
        isSetting: Bool = false,
        settingName: String = ""
    ) {
        self.name = name
        self.baseColor = baseColor
        self.icon = icon
        self.isSetting = isSetting
        self.settingName = settingName
    }
}
