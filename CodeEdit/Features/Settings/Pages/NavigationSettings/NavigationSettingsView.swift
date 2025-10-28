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
        Picker("Navigation Style", selection: $settings.navigationStyle) {
            Text("settings.navigation.open_in_tabs", comment: "Navigation style option")
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text("settings.navigation.open_in_place", comment: "Navigation style option")
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
