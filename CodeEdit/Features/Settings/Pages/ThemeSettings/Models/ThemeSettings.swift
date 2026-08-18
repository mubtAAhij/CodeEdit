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
                String(
                    localized: "settings.theme.automatic-change-based-on-system-appearance",
                    defaultValue: "Automatically Change theme based on system appearance",
                    comment: "Theme setting option to automatically switch based on system appearance."
                ),
                String(
                    localized: "settings.theme.always-use-dark-terminal-appearance",
                    defaultValue: "Always use dark terminal appearance",
                    comment: "Theme setting option to always use dark terminal appearance."
                ),
                String(
                    localized: "settings.theme.use-theme-background",
                    defaultValue: "Use theme background",
                    comment: "Theme setting option to use theme background in terminal."
                ),
                String(
                    localized: "settings.theme.option.light-appearance",
                    defaultValue: "Light Appearance",
                    comment: "Theme appearance option for light mode."
                ),
                String(
                    localized: "settings.theme.option.github-light",
                    defaultValue: "GitHub Light",
                    comment: "Theme option name for GitHub Light."
                ),
                String(
                    localized: "settings.theme.option.xcode-light",
                    defaultValue: "Xcode Light",
                    comment: "Theme option name for Xcode Light."
                ),
                String(
                    localized: "settings.theme.option.solarized-light",
                    defaultValue: "Solarized Light",
                    comment: "Theme option name for Solarized Light."
                ),
                String(
                    localized: "settings.theme.option.solarized-dark",
                    defaultValue: "Solarized Dark",
                    comment: "Theme option name for Solarized Dark."
                ),
                String(
                    localized: "settings.theme.option.midnight",
                    defaultValue: "Midnight",
                    comment: "Theme option name for Midnight."
                ),
                String(
                    localized: "settings.theme.option.xcode-dark",
                    defaultValue: "Xcode Dark",
                    comment: "Theme option name for Xcode Dark."
                ),
                String(
                    localized: "settings.theme.option.github-dark",
                    defaultValue: "GitHub Dark",
                    comment: "Theme option name for GitHub Dark."
                )
            ]
            .map { NSLocalizedString($0, comment: "") }
        }

        /// The name of the currently selected dark theme
        var selectedDarkTheme: String = String(
            localized: "settings.theme.default.dark",
            defaultValue: "Default (Dark)",
            comment: "Default dark theme display name."
        )

        /// The name of the currently selected light theme
        var selectedLightTheme: String = String(
            localized: "settings.theme.default.light",
            defaultValue: "Default (Light)",
            comment: "Default light theme display name."
        )

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
