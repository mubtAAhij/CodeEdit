//
//  NavigationSettingsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 3/4/24.
//

import SwiftUI

struct NavigationSettingsView: View {
    @AppSettings(\.navigation)
    var settings

    var body: some View {
        SettingsForm {
            Section {
                navigationStyle
            }
        }
    }
}

private extension NavigationSettingsView {
    private var navigationStyle: some View {
        Picker(String(localized: "settings.navigation.style", defaultValue: "Navigation Style", comment: "Navigation style setting"), selection: $settings.navigationStyle) {
            Text(String(localized: "settings.navigation.open-in-tabs", defaultValue: "Open in Tabs", comment: "Open in tabs option"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "settings.navigation.open-in-place", defaultValue: "Open in Place", comment: "Open in place option"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
