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

        var rawValue: String {
            switch self {
            case .general:
                return "General"
            case .accounts:
                return "Accounts"
            case .behavior:
                return "Behaviors"
            case .navigation:
                return "Navigation"
            case .theme:
                return "Themes"
            case .textEditing:
                return "Text Editing"
            case .terminal:
                return "Terminal"
            case .search:
                return String(
                    localized: "settings.page.search",
                    defaultValue: "Search",
                    comment: "Settings page name for search settings"
                )
            case .keybindings:
                return "Key Bindings"
            case .sourceControl:
                return String(
                    localized: "settings.page.source-control",
                    defaultValue: "Source Control",
                    comment: "Settings page name for source control settings"
                )
            case .components:
                return String(
                    localized: "settings.page.components",
                    defaultValue: "Components",
                    comment: "Settings page name for components settings"
                )
            case .location:
                return String(
                    localized: "settings.page.locations",
                    defaultValue: "Locations",
                    comment: "Settings page name for locations settings"
                )
            case .advanced:
                return String(
                    localized: "settings.page.advanced",
                    defaultValue: "Advanced",
                    comment: "Settings page name for advanced settings"
                )
            case .languageServers:
                return "Language Servers"
            case .developer:
                return String(
                    localized: "settings.page.developer",
                    defaultValue: "Developer",
                    comment: "Settings page name for developer settings"
                )
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
