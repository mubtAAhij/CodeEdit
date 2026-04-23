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
        case general = "settings-page.general"
        case accounts = "settings-page.accounts"
        case behavior = "settings-page.behaviors"
        case navigation = "settings-page.navigation"
        case theme = "settings-page.themes"
        case textEditing = "settings-page.text-editing"
        case terminal = "settings-page.terminal"
        case search = "settings-page.search"
        case keybindings = "settings-page.key-bindings"
        case sourceControl = "settings-page.source-control"
        case components = "settings-page.components"
        case location = "settings-page.locations"
        case advanced = "settings-page.advanced"
        case languageServers = "settings-page.language-servers"
        case developer = "settings-page.developer"
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
