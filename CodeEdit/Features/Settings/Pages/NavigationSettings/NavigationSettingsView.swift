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
        Picker(String(localized: "navigation_style", comment: "Navigation style picker label"), selection: $settings.navigationStyle) {
            Text(String(localized: "open_in_tabs", comment: "Navigation option to open files in tabs"))
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text(String(localized: "open_in_place", comment: "Navigation option to open files in place"))
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
