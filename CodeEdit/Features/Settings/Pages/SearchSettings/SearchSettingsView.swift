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
                Text("Exclude", comment: "Search settings section header")
                Text(
                    "Add glob patterns to exclude matching files and folders from searches and open quickly. " +
                    "This will inherit glob patterns from the Exclude from Project setting.",
                    comment: "Search settings description explaining glob pattern exclusion"
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
            emptyMessage: String(localized: "No excluded glob patterns", comment: "Empty state message when no search exclusions are configured")
        )
    }
}
