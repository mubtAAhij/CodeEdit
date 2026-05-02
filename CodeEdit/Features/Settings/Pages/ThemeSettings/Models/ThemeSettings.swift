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
                String(localized: "settings.theme.search.auto-change", defaultValue: "Automatically Change theme based on system appearance", comment: "Search key for auto change theme setting"),
                String(localized: "settings.theme.search.dark-terminal", defaultValue: "Always use dark terminal appearance", comment: "Search key for dark terminal appearance setting"),
                String(localized: "settings.theme.search.use-background", defaultValue: "Use theme background", comment: "Search key for use theme background setting"),
                String(localized: "settings.theme.search.light-appearance", defaultValue: "Light Appearance", comment: "Search key for light appearance"),
                String(localized: "settings.theme.search.github-light", defaultValue: "GitHub Light", comment: "Search key for GitHub Light theme"),
                String(localized: "settings.theme.search.xcode-light", defaultValue: "Xcode Light", comment: "Search key for Xcode Light theme"),
                String(localized: "settings.theme.search.solarized-light", defaultValue: "Solarized Light", comment: "Search key for Solarized Light theme"),
                String(localized: "settings.theme.search.solarized-dark", defaultValue: "Solarized Dark", comment: "Search key for Solarized Dark theme"),
                String(localized: "settings.theme.search.midnight", defaultValue: "Midnight", comment: "Search key for Midnight theme"),
                String(localized: "settings.theme.search.xcode-dark", defaultValue: "Xcode Dark", comment: "Search key for Xcode Dark theme"),
                String(localized: "settings.theme.search.github-dark", defaultValue: "GitHub Dark", comment: "Search key for GitHub Dark theme")
            ]
        }

        /// The name of the currently selected dark theme
        var selectedDarkTheme: String = String(localized: "settings.theme.default-dark", defaultValue: "Default (Dark)", comment: "Default dark theme name")

        /// The name of the currently selected light theme
        var selectedLightTheme: String = String(localized: "settings.theme.default-light", defaultValue: "Default (Light)", comment: "Default light theme name")

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
