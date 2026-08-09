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
        case general = String(localized: "settings.page.general", defaultValue: "General", comment: "Settings page title for general preferences")
        case accounts = String(localized: "settings.page.accounts", defaultValue: "Accounts", comment: "Settings page title for accounts preferences")
        case behavior = String(localized: "settings.page.behaviors", defaultValue: "Behaviors", comment: "Settings page title for behavior preferences")
        case navigation = String(localized: "settings.page.navigation", defaultValue: "Navigation", comment: "Settings page title for navigation preferences")
        case theme = String(localized: "settings.page.themes", defaultValue: "Themes", comment: "Settings page title for themes preferences")
        case textEditing = String(localized: "settings.page.text-editing", defaultValue: "Text Editing", comment: "Settings page title for text editing preferences")
        case terminal = String(localized: "settings.page.terminal", defaultValue: "Terminal", comment: "Settings page title for terminal preferences")
        case search = String(localized: "settings.page.search", defaultValue: "Search", comment: "Settings page title for search preferences")
        case keybindings = String(localized: "settings.page.key_bindings", defaultValue: "Key Bindings", comment: "Settings page title for key bindings preferences")
        case sourceControl = String(localized: "settings.page.source-control", defaultValue: "Source Control", comment: "Settings page title for source control preferences")
        case components = String(localized: "settings.page.components", defaultValue: "Components", comment: "Settings page title for components preferences")
        case location = String(localized: "settings.page.locations", defaultValue: "Locations", comment: "Settings page title for locations preferences")
        case advanced = String(localized: "settings.page.advanced", defaultValue: "Advanced", comment: "Settings page title for advanced preferences")
        case languageServers = String(localized: "settings.page.language_servers", defaultValue: "Language Servers", comment: "Settings page title for language server preferences")
        case developer = String(localized: "settings.page.developer", defaultValue: "Developer", comment: "Settings page title for developer preferences")
    }

    let id: UUID = .init()

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
