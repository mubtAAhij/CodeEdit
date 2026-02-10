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
                NSLocalizedString("settings.locations.settings-location", comment: "Settings Location"),
                NSLocalizedString("settings.locations.themes-location", comment: "Themes Location"),
                NSLocalizedString("settings.locations.extensions-location", comment: "Extensions Location")
            ]
        }
    }
}
