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
                String(localized: "settings.locations.settings-location", defaultValue: "Settings Location", comment: "Settings item title for app settings storage location"),
                String(localized: "settings.locations.themes-location", defaultValue: "Themes Location", comment: "Settings item title for themes storage location"),
                String(localized: "settings.locations.extensions-location", defaultValue: "Extensions Location", comment: "Settings item title for extensions storage location"),
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
