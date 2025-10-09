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
            Text(String(localized: "navigation.open_in_tabs", comment: "Option to open files in tabs"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "navigation.open_in_place", comment: "Option to open files in place"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
