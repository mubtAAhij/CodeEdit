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
                String(localized: "settings.locations.settings", defaultValue: "Settings Location", comment: "Settings location label"),
                String(localized: "settings.locations.themes", defaultValue: "Themes Location", comment: "Themes location label"),
                String(localized: "settings.locations.extensions", defaultValue: "Extensions Location", comment: "Extensions location label")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
