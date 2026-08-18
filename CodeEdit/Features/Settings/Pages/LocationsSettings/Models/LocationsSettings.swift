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
                String(localized: "settings.locations.settings-location", defaultValue: "Settings Location", comment: "Label for settings file location preference"),
                String(localized: "settings.locations.themes-location", defaultValue: "Themes Location", comment: "Label for themes directory location preference"),
                String(localized: "settings.locations.extensions-location", defaultValue: "Extensions Location", comment: "Label for extensions directory location preference")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
