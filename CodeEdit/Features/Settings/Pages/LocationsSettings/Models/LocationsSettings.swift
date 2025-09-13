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
                String(localized: "settings_location", comment: "Locations settings search key for settings directory"),
                String(localized: "themes_location", comment: "Locations settings search key for themes directory"),
                String(localized: "extensions_location", comment: "Locations settings search key for extensions directory")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
