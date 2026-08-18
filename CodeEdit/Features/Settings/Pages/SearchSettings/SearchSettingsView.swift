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
                Text(String(localized: "settings.search.exclude.title", defaultValue: "Exclude", comment: "Title for search exclude settings section"))
                Text(
                    String(localized: "settings.search.exclude.description", defaultValue: "Add glob patterns to exclude matching files and folders from searches and open quickly. This will inherit glob patterns from the Exclude from Project setting.", comment: "Description for search exclude glob patterns behavior")
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
            emptyMessage: String(localized: "settings.search.exclude.empty-state", defaultValue: "No excluded glob patterns", comment: "Empty state text when no excluded glob patterns are configured")
        )
    }
}
