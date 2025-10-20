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
            Text(String(localized: "navigation.openInTabs", comment: "Navigation option"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "navigation.openInPlace", comment: "Navigation option"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
