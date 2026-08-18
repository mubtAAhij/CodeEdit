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
                Text(String(
                    localized: "settings.search.exclude.title",
                    defaultValue: "Exclude",
                    comment: "Title for exclude patterns section in search settings"
                ))
                Text(
                    String(
                        localized: "settings.search.exclude.description",
                        defaultValue: "Add glob patterns to exclude matching files and folders from searches and open quickly. This will inherit glob patterns from the Exclude from Project setting.",
                        comment: "Description explaining exclude glob pattern behavior for search"
                    )
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
            emptyMessage: String(
                localized: "settings.search.exclude.none",
                defaultValue: "No excluded glob patterns",
                comment: "Empty state message when no search exclude glob patterns are configured"
            )
        )
    }
}
