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

        var localizedString: String {
            switch self {
            case .general:
                return String(localized: "settings.general", defaultValue: "General", comment: "General settings page title")
            case .accounts:
                return String(localized: "settings.accounts", defaultValue: "Accounts", comment: "Accounts settings page title")
            case .behavior:
                return String(localized: "settings.behaviors", defaultValue: "Behaviors", comment: "Behaviors settings page title")
            case .navigation:
                return String(localized: "settings.navigation", defaultValue: "Navigation", comment: "Navigation settings page title")
            case .theme:
                return String(localized: "settings.themes", defaultValue: "Themes", comment: "Themes settings page title")
            case .textEditing:
                return String(localized: "settings.text-editing", defaultValue: "Text Editing", comment: "Text Editing settings page title")
            case .terminal:
                return String(localized: "settings.terminal", defaultValue: "Terminal", comment: "Terminal settings page title")
            case .search:
                return String(localized: "settings.search", defaultValue: "Search", comment: "Search settings page title")
            case .keybindings:
                return String(localized: "settings.key-bindings", defaultValue: "Key Bindings", comment: "Key Bindings settings page title")
            case .sourceControl:
                return String(localized: "settings.source-control", defaultValue: "Source Control", comment: "Source Control settings page title")
            case .components:
                return String(localized: "settings.components", defaultValue: "Components", comment: "Components settings page title")
            case .location:
                return String(localized: "settings.locations", defaultValue: "Locations", comment: "Locations settings page title")
            case .advanced:
                return String(localized: "settings.advanced", defaultValue: "Advanced", comment: "Advanced settings page title")
            case .languageServers:
                return String(localized: "settings.language-servers", defaultValue: "Language Servers", comment: "Language Servers settings page title")
            case .developer:
                return String(localized: "settings.developer", defaultValue: "Developer", comment: "Developer settings page title")
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
