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
                String(localized: "locations-settings.settings-location", defaultValue: "Settings Location", comment: "Settings location search key"),
                String(localized: "locations-settings.themes-location", defaultValue: "Themes Location", comment: "Themes location search key"),
                String(localized: "locations-settings.extensions-location", defaultValue: "Extensions Location", comment: "Extensions location search key")
            ]
        }
    }
}
