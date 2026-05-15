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
        Picker(String(localized: "settings.navigation.style.label", defaultValue: "Navigation Style", comment: "Navigation Style picker label"), selection: $settings.navigationStyle) {
            Text(String(localized: "settings.navigation.style.open-in-tabs", defaultValue: "Open in Tabs", comment: "Open in Tabs navigation option"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "settings.navigation.style.open-in-place", defaultValue: "Open in Place", comment: "Open in Place navigation option"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
