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
        case search = "Search"
        case keybindings = "Key Bindings"
        case sourceControl = "Source Control"
        case components = "Components"
        case location = "Locations"
        case advanced = "Advanced"
        case languageServers = "Language Servers"
        case developer = "Developer"

        var localizedName: String {
            switch self {
            case .general:
                return String(localized: "settings.page.general", defaultValue: "General", comment: "General settings page name")
            case .accounts:
                return String(localized: "settings.page.accounts", defaultValue: "Accounts", comment: "Accounts settings page name")
            case .behavior:
                return String(localized: "settings.page.behaviors", defaultValue: "Behaviors", comment: "Behaviors settings page name")
            case .navigation:
                return String(localized: "settings.page.navigation", defaultValue: "Navigation", comment: "Navigation settings page name")
            case .theme:
                return String(localized: "settings.page.themes", defaultValue: "Themes", comment: "Themes settings page name")
            case .textEditing:
                return String(localized: "settings.page.text-editing", defaultValue: "Text Editing", comment: "Text Editing settings page name")
            case .terminal:
                return String(localized: "settings.page.terminal", defaultValue: "Terminal", comment: "Terminal settings page name")
            case .search:
                return String(localized: "settings.page.search", defaultValue: "Search", comment: "Search settings page name")
            case .keybindings:
                return String(localized: "settings.page.key-bindings", defaultValue: "Key Bindings", comment: "Key Bindings settings page name")
            case .sourceControl:
                return String(localized: "settings.page.source-control", defaultValue: "Source Control", comment: "Source Control settings page name")
            case .components:
                return String(localized: "settings.page.components", defaultValue: "Components", comment: "Components settings page name")
            case .location:
                return String(localized: "settings.page.locations", defaultValue: "Locations", comment: "Locations settings page name")
            case .advanced:
                return String(localized: "settings.page.advanced", defaultValue: "Advanced", comment: "Advanced settings page name")
            case .languageServers:
                return String(localized: "settings.page.language-servers", defaultValue: "Language Servers", comment: "Language Servers settings page name")
            case .developer:
                return String(localized: "settings.page.developer", defaultValue: "Developer", comment: "Developer settings page name")
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
