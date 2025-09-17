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
                Text(String(localized: "exclude", comment: "Section header for exclusion settings"))
                Text(
                    String(localized: "exclude_glob_patterns_description", comment: "Description for exclude glob patterns functionality") +
                    String(localized: "exclude_inherit_description", comment: "Description for pattern inheritance from project settings")
                )
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
            emptyMessage: String(localized: "no_excluded_patterns", comment: "Empty state message for excluded patterns list")
        )
    }
}
