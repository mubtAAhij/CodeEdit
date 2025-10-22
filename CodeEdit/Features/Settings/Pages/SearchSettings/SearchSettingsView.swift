//
//  SearchSettingsView.swift
//  CodeEdit
//
//  Created by Esteban on 12/10/23.
//

import SwiftUI

struct SearchSettingsView: View {
    var body: some View {
        SettingsForm {
            Section {
                ExcludedGlobPatternList()
            } header: {
                Text("search_settings.exclude")
                Text("search_settings.exclude_description")
            }
        }
    }
}

struct ExcludedGlobPatternList: View {
    @ObservedObject private var model: SearchSettingsModel = .shared

    var body: some View {
        GlobPatternList(
            patterns: $model.ignoreGlobPatterns,
            selection: $model.selection,
            addPattern: model.addPattern,
            removePatterns: model.removePatterns,
            emptyMessage: String(localized: "search_settings.no_excluded_patterns")
        )
    }
}
