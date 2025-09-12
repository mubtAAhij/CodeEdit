//
//  LocationsSettings.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 24/06/23.
//

import Foundation

extension SettingsData {

    struct LocationsSettings: SearchableSettingsPage {

        /// The search keys
        var searchKeys: [String] {
            [
                String(localized: "settings_location_search", comment: "Search key for settings location"),
                String(localized: "themes_location", comment: "Search key for themes location"),
                String(localized: "extensions_location_search", comment: "Search key for extensions location")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
