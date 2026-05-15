//
//  SourceControlGeneralView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct SourceControlGeneralView: View {
    @AppSettings(\.sourceControl.general)
    var settings

    let gitConfig = GitConfigClient(shellClient: currentWorld.shellClient)

    var body: some View {
        Group {
            Section(String(localized: "settings.source-control.section.source-control", defaultValue: "Source Control", comment: "Source control settings section title")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.section.text-editing", defaultValue: "Text Editing", comment: "Text editing settings section title")) {
                showSourceControlChanges
                includeUpstreamChanges
            }
            Section {
                comparisonView
                sourceControlNavigator
            }
        }
    }
}

private extension SourceControlGeneralView {
    private var refreshLocalStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.refresh-local-status", defaultValue: "Refresh local status automatically", comment: "Toggle to refresh local status automatically"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.fetch-refresh-server-status", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle to fetch and refresh server status automatically"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.add-remove-files", defaultValue: "Add and remove files automatically", comment: "Toggle to add and remove files automatically"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.select-files-to-commit", defaultValue: "Select files to commit automatically", comment: "Toggle to select files to commit automatically"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.show-changes", defaultValue: "Show source control changes", comment: "Toggle to show source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Toggle to include upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.comparison-view", defaultValue: "Comparison view", comment: "Comparison view picker label"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.comparison-view.local-left", defaultValue: "Local Revision on Left Side", comment: "Local revision on left side option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.comparison-view.local-right", defaultValue: "Local Revision on Right Side", comment: "Local revision on right side option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.navigator", defaultValue: "Source control navigator", comment: "Source control navigator picker label"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.navigator.sort-by-name", defaultValue: "Sort by Name", comment: "Sort by name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.navigator.sort-by-date", defaultValue: "Sort by Date", comment: "Sort by date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
