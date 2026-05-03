//
//  ThemePreferences.swift
//  CodeEditModules/Settings
//
//  Created by Nanashi Li on 2022/04/08.
//

import Foundation

extension SettingsData {

    /// A dictionary containing the keys and associated ``Theme/Attributes`` of overridden properties
    ///
    /// ```json
    /// {
    ///   "editor" : {
    ///     "background" : {
    ///       "color" : "#123456"
    ///     },
    ///     ...
    ///   },
    ///   "terminal" : {
    ///     "blue" : {
    ///       "color" : "#1100FF"
    ///     },
    ///     ...
    ///   }
    /// }
    /// ```
    typealias ThemeOverrides = [String: [String: Theme.Attributes]]

    /// The global settings for themes
    struct ThemeSettings: Codable, Hashable, SearchableSettingsPage {

        var searchKeys: [String] {
            [
                String(localized: "theme.search.auto_change_appearance", defaultValue: "Automatically Change theme based on system appearance", comment: "Search key for automatic theme switching based on system appearance"),
                String(localized: "theme.search.dark_terminal", defaultValue: "Always use dark terminal appearance", comment: "Search key for always using dark terminal appearance"),
                String(localized: "theme.search.use_theme_background", defaultValue: "Use theme background", comment: "Search key for using theme background setting"),
                String(localized: "theme.search.light_appearance", defaultValue: "Light Appearance", comment: "Search key for light appearance settings"),
                String(localized: "theme.name.github_light", defaultValue: "GitHub Light", comment: "GitHub Light theme name"),
                String(localized: "theme.name.xcode_light", defaultValue: "Xcode Light", comment: "Xcode Light theme name"),
                String(localized: "theme.name.solarized_light", defaultValue: "Solarized Light", comment: "Solarized Light theme name"),
                String(localized: "theme.name.solarized_dark", defaultValue: "Solarized Dark", comment: "Solarized Dark theme name"),
                String(localized: "theme.name.midnight", defaultValue: "Midnight", comment: "Midnight theme name"),
                String(localized: "theme.name.xcode_dark", defaultValue: "Xcode Dark", comment: "Xcode Dark theme name"),
                String(localized: "theme.name.github_dark", defaultValue: "GitHub Dark", comment: "GitHub Dark theme name")
            ]
        }

        /// The name of the currently selected dark theme
        var selectedDarkTheme: String = String(localized: "theme.default.dark", defaultValue: "Default (Dark)", comment: "Default dark theme name")

        /// The name of the currently selected light theme
        var selectedLightTheme: String = String(localized: "theme.default.light", defaultValue: "Default (Light)", comment: "Default light theme name")

        /// The name of the currently selected theme
        var selectedTheme: String?

        /// Use the system background that matches the appearance setting
        var useThemeBackground: Bool = true

        /// Automatically change theme based on system appearance
        var matchAppearance: Bool = true

        /// Dictionary of themes containing overrides
        ///
        /// ```json
        /// {
        ///   "overrides" : {
        ///     "DefaultDark" : {
        ///       "editor" : {
        ///         "background" : {
        ///           "color" : "#123456"
        ///         },
        ///         ...
        ///       },
        ///       "terminal" : {
        ///         "blue" : {
        ///           "color" : "#1100FF"
        ///         },
        ///         ...
        ///       }
        ///       ...
        ///     },
        ///     ...
        ///   },
        ///   ...
        /// }
        /// ```
        var overrides: [String: ThemeOverrides] = [:]

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.selectedDarkTheme = try container.decodeIfPresent(
                String.self, forKey: .selectedDarkTheme
            ) ?? selectedDarkTheme
            self.selectedLightTheme = try container.decodeIfPresent(
                String.self, forKey: .selectedLightTheme
            ) ?? selectedLightTheme
            self.selectedTheme = try container.decodeIfPresent(String.self, forKey: .selectedTheme)
            self.useThemeBackground = try container.decodeIfPresent(Bool.self, forKey: .useThemeBackground) ?? true
            self.matchAppearance = try container.decodeIfPresent(
                Bool.self, forKey: .matchAppearance
            ) ?? true
            self.overrides = try container.decodeIfPresent([String: ThemeOverrides].self, forKey: .overrides) ?? [:]
        }
    }
}
