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
                "Settings Location",
                String(localized: "themes_location", comment: "Search key for themes location setting"),
                String(localized: "extensions_location", comment: "Search key for extensions location setting")
            ]
            .map { NSLocalizedString($0, comment: "") }
        }
    }
}
