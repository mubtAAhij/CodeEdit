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
                Text(String(localized: "search-settings.exclude", defaultValue: "Exclude", comment: "Exclude section header"))
                Text(String(localized: "search-settings.exclude-description", defaultValue: "Add glob patterns to exclude matching files and folders from searches and open quickly. This will inherit glob patterns from the Exclude from Project setting.", comment: "Exclude section description"))
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
            emptyMessage: String(localized: "search-settings.no-excluded-patterns", defaultValue: "No excluded glob patterns", comment: "No excluded patterns message")
        )
    }
}
