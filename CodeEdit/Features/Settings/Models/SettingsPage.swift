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
        case behavior = "behaviors"
        case navigation = "navigation"
        case theme = "themes"
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
    }

    let id: UUID = UUID()

    let name: Name
    let baseColor: Color?
    let isSetting: Bool
    let settingName: String
    var nameString: LocalizedStringKey {
        switch name {
        case .general: return "settings.general"
        case .accounts: return "settings.accounts"
        case .behavior: return "settings.behaviors"
        case .navigation: return "settings.navigation"
        case .theme: return "settings.themes"
        case .textEditing: return "settings.text_editing"
        case .terminal: return "settings.terminal"
        case .search: return "settings.search"
        case .keybindings: return "settings.key_bindings"
        case .sourceControl: return "settings.source_control"
        case .components: return "settings.components"
        case .location: return "settings.locations"
        case .advanced: return "settings.advanced"
        case .languageServers: return "settings.language_servers"
        case .developer: return "settings.developer"
        }
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
