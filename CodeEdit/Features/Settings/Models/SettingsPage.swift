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
        case search = String(localized: "settings.page.search", defaultValue: "Search", comment: "Search settings page name")
        case keybindings = "Key Bindings"
        case sourceControl = String(localized: "settings.page.source-control", defaultValue: "Source Control", comment: "Source control settings page name")
        case components = String(localized: "settings.page.components", defaultValue: "Components", comment: "Components settings page name")
        case location = String(localized: "settings.page.locations", defaultValue: "Locations", comment: "Locations settings page name")
        case advanced = String(localized: "settings.page.advanced", defaultValue: "Advanced", comment: "Advanced settings page name")
        case languageServers = "Language Servers"
        case developer = String(localized: "settings.page.developer", defaultValue: "Developer", comment: "Developer settings page name")
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
