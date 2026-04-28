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
        case general = "settings.general"
        case accounts = "settings.accounts"
        case behavior = "settings.behaviors"
        case navigation = "settings.navigation"
        case theme = "settings.themes"
        case textEditing = "settings.text-editing"
        case terminal = "settings.terminal"
        case search = "settings.search"
        case keybindings = "settings.key-bindings"
        case sourceControl = "settings.source-control"
        case components = "settings.components"
        case location = "settings.locations"
        case advanced = "settings.advanced"
        case languageServers = "Language Servers"
        case developer = "settings.developer"
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
