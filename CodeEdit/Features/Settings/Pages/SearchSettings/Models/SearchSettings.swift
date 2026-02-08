//
//  SearchSettings.swift
//  CodeEdit
//
//  Created by Esteban on 12/10/23.
//

import Foundation

extension SettingsData {
    struct SearchSettings: Codable, Hashable, SearchableSettingsPage {

        /// The search keys
        var searchKeys: [String] {
            [
                NSLocalizedString("search-settings.ignore-glob-patterns", comment: "Ignore Glob Patterns"),
                NSLocalizedString("search-settings.ignore-patterns", comment: "Ignore Patterns")
            ]
        }

        /// List of Glob Patterns that determine which files or directories to ignore
        var ignoreGlobPatterns: [GlobPattern] = .init()

        /// Default initializer
        init() {}

        /// Explicit decoder init for setting default values when key is not present in `JSON`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.ignoreGlobPatterns = try container.decodeIfPresent(
                [GlobPattern].self,
                forKey: .ignoreGlobPatterns
            ) ?? []
        }
    }
}
