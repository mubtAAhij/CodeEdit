//
//  LocationSettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

/// A view that implements the `Locations` settings section
struct LocationsSettingsView: View {
    var body: some View {
        SettingsForm {
            Section {
                applicationSupportLocation
                settingsLocation
                themesLocation
                extensionsLocation
            }
        }
    }
}

private extension LocationsSettingsView {
    @ViewBuilder private var applicationSupportLocation: some View {
        ExternalLink(destination: Settings.shared.baseURL) {
            Text("locations.application_support", comment: "Application Support folder label")
            Text(Settings.shared.baseURL.path)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var settingsLocation: some View {
        ExternalLink(destination: ThemeModel.shared.settingsURL) {
            Text("Settings")
            Text(ThemeModel.shared.settingsURL.path)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var themesLocation: some View {
        ExternalLink(destination: ThemeModel.shared.themesURL) {
            Text("Themes")
            Text(ThemeModel.shared.themesURL.path)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var extensionsLocation: some View {
        ExternalLink(destination: ThemeModel.shared.extensionsURL) {
            Text("locations.extensions", comment: "Extensions folder label")
            Text(ThemeModel.shared.extensionsURL.path())
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}
