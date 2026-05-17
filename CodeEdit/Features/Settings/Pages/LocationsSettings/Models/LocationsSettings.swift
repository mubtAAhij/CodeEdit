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
                String(localized: "settings.locations.settings", defaultValue: "Settings Location", comment: "Settings search key for settings location"),
                String(localized: "settings.locations.themes", defaultValue: "Themes Location", comment: "Settings search key for themes location"),
                String(localized: "settings.locations.extensions", defaultValue: "Extensions Location", comment: "Settings search key for extensions location")
            ]
        }
    }
}
