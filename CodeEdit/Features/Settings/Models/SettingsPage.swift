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
        case general
        case accounts
        case behavior
        case navigation
        case theme
        case textEditing
        case terminal
        case search
        case keybindings
        case sourceControl
        case components
        case location
        case advanced
        case languageServers
        case developer

        var rawValue: String {
            switch self {
            case .general:
                return String(localized: "settings.page.general", defaultValue: "General", comment: "General settings page")
            case .accounts:
                return String(localized: "settings.page.accounts", defaultValue: "Accounts", comment: "Accounts settings page")
            case .behavior:
                return String(localized: "settings.page.behaviors", defaultValue: "Behaviors", comment: "Behaviors settings page")
            case .navigation:
                return String(localized: "settings.page.navigation", defaultValue: "Navigation", comment: "Navigation settings page")
            case .theme:
                return String(localized: "settings.page.themes", defaultValue: "Themes", comment: "Themes settings page")
            case .textEditing:
                return String(localized: "settings.page.text-editing", defaultValue: "Text Editing", comment: "Text Editing settings page")
            case .terminal:
                return String(localized: "settings.page.terminal", defaultValue: "Terminal", comment: "Terminal settings page")
            case .search:
                return String(localized: "settings.page.search", defaultValue: "Search", comment: "Search settings page")
            case .keybindings:
                return String(localized: "settings.page.key-bindings", defaultValue: "Key Bindings", comment: "Key Bindings settings page")
            case .sourceControl:
                return String(localized: "settings.page.source-control", defaultValue: "Source Control", comment: "Source Control settings page")
            case .components:
                return String(localized: "settings.page.components", defaultValue: "Components", comment: "Components settings page")
            case .location:
                return String(localized: "settings.page.locations", defaultValue: "Locations", comment: "Locations settings page")
            case .advanced:
                return String(localized: "settings.page.advanced", defaultValue: "Advanced", comment: "Advanced settings page")
            case .languageServers:
                return "Language Servers"
            case .developer:
                return String(localized: "settings.page.developer", defaultValue: "Developer", comment: "Developer settings page")
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
