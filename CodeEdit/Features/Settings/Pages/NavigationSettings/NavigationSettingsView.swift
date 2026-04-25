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
        Picker(String(localized: "settings.navigation.style.label", defaultValue: "Navigation Style", comment: "Label for navigation style picker"), selection: $settings.navigationStyle) {
            Text(String(localized: "settings.navigation.style.tabs", defaultValue: "Open in Tabs", comment: "Navigation style option for opening in tabs"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "settings.navigation.style.in-place", defaultValue: "Open in Place", comment: "Navigation style option for opening in place"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
