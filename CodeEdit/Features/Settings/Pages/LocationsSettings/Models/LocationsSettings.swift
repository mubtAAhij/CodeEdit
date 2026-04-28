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
                String(localized: "locations-settings.settings-location", defaultValue: "Settings Location", comment: "Search key for settings location"),
                String(localized: "locations-settings.themes-location", defaultValue: "Themes Location", comment: "Search key for themes location"),
                String(localized: "locations-settings.extensions-location", defaultValue: "Extensions Location", comment: "Search key for extensions location")
            ]
        }
    }
}
