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
        Picker(String(localized: "settings.navigation.style.label", defaultValue: "Navigation Style", comment: "Navigation style picker label"), selection: $settings.navigationStyle) {
            Text(String(localized: "settings.navigation.style.tabs", defaultValue: "Open in Tabs", comment: "Open in tabs navigation option"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "settings.navigation.style.place", defaultValue: "Open in Place", comment: "Open in place navigation option"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
