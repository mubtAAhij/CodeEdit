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
        case general = "general"
        case accounts = "accounts"
        case behavior = "behavior"
        case navigation = "navigation"
        case theme = "theme"
        case textEditing = "textEditing"
        case terminal = "terminal"
        case search = "search"
        case keybindings = "keybindings"
        case sourceControl = "sourceControl"
        case components = "components"
        case location = "location"
        case advanced = "advanced"
        case languageServers = "languageServers"
        case developer = "developer"

        /// Returns the localized display name for this settings page
        var localizedName: String {
            switch self {
            case .general:
                return String(localized: "settings.page.general", defaultValue: "General", comment: "Settings page name for general preferences")
            case .accounts:
                return String(localized: "settings.page.accounts", defaultValue: "Accounts", comment: "Settings page name for account management")
            case .behavior:
                return String(localized: "settings.page.behavior", defaultValue: "Behaviors", comment: "Settings page name for behavior customization")
            case .navigation:
                return String(localized: "settings.page.navigation", defaultValue: "Navigation", comment: "Settings page name for navigation settings")
            case .theme:
                return String(localized: "settings.page.theme", defaultValue: "Themes", comment: "Settings page name for theme customization")
            case .textEditing:
                return String(localized: "settings.page.text-editing", defaultValue: "Text Editing", comment: "Settings page name for text editing preferences")
            case .terminal:
                return String(localized: "settings.page.terminal", defaultValue: "Terminal", comment: "Settings page name for terminal settings")
            case .search:
                return String(localized: "settings.page.search", defaultValue: "Search", comment: "Settings page name for search configuration")
            case .keybindings:
                return String(localized: "settings.page.keybindings", defaultValue: "Key Bindings", comment: "Settings page name for keyboard shortcuts")
            case .sourceControl:
                return String(localized: "settings.page.source-control", defaultValue: "Source Control", comment: "Settings page name for version control settings")
            case .components:
                return String(localized: "settings.page.components", defaultValue: "Components", comment: "Settings page name for component configuration")
            case .location:
                return String(localized: "settings.page.location", defaultValue: "Locations", comment: "Settings page name for file location preferences")
            case .advanced:
                return String(localized: "settings.page.advanced", defaultValue: "Advanced", comment: "Settings page name for advanced settings")
            case .languageServers:
                return String(localized: "settings.page.language-servers", defaultValue: "Language Servers", comment: "Settings page name for language server configuration")
            case .developer:
                return String(localized: "settings.page.developer", defaultValue: "Developer", comment: "Settings page name for developer options")
            }
        }
    }

    let id: UUID = UUID()

    let name: Name
    let baseColor: Color?
    let isSetting: Bool
    let settingName: String
    var nameString: LocalizedStringKey {
        LocalizedStringKey(name.localizedName)
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
