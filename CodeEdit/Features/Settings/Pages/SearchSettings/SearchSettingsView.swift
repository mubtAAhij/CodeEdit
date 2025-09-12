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
                Text(String(localized: "exclude", comment: "Section header for exclude settings"))
                Text(
                    String(localized: "add_glob_patterns_description", comment: "Description for glob patterns functionality") +
                    String(localized: "inherit_glob_patterns_note", comment: "Note about inheriting glob patterns from project settings")
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
            emptyMessage: String(localized: "no_excluded_glob_patterns", comment: "Empty state message when no glob patterns are excluded")
        )
    }
}
