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
    }

    let id: UUID = UUID()

    let name: Name
    let baseColor: Color?
    let isSetting: Bool
    let settingName: String
    var nameString: LocalizedStringKey {
        switch name {
        case .search:
            return LocalizedStringKey(String(localized: "settingsPage.search", comment: "Tab title"))
        case .sourceControl:
            return LocalizedStringKey(String(localized: "settingsPage.sourceControl", comment: "Tab title"))
        case .components:
            return LocalizedStringKey(String(localized: "settingsPage.components", comment: "Tab title"))
        case .location:
            return LocalizedStringKey(String(localized: "settingsPage.locations", comment: "Tab title"))
        case .advanced:
            return LocalizedStringKey(String(localized: "settingsPage.advanced", comment: "Tab title"))
        case .developer:
            return LocalizedStringKey(String(localized: "settingsPage.developer", comment: "Tab title"))
        default:
            return LocalizedStringKey(name.rawValue)
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
