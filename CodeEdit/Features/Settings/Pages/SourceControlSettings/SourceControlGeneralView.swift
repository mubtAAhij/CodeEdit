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
            Section(String(localized: "settings.source-control.title", defaultValue: "Source Control", comment: "Source control section header")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.text-editing", defaultValue: "Text Editing", comment: "Text editing section header")) {
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
            String(localized: "settings.source-control.refresh-local-status-automatically", defaultValue: "Refresh local status automatically", comment: "Refresh local status toggle"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.fetch-refresh-server-status-automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Fetch and refresh server status toggle"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.add-remove-files-automatically", defaultValue: "Add and remove files automatically", comment: "Add and remove files toggle"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.select-files-to-commit-automatically", defaultValue: "Select files to commit automatically", comment: "Select files to commit toggle"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.show-source-control-changes", defaultValue: "Show source control changes", comment: "Show source control changes toggle"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Include upstream changes toggle"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.comparison-view", defaultValue: "Comparison view", comment: "Comparison view picker label"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.local-revision-left", defaultValue: "Local Revision on Left Side", comment: "Local revision on left side option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.local-revision-right", defaultValue: "Local Revision on Right Side", comment: "Local revision on right side option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.navigator", defaultValue: "Source control navigator", comment: "Source control navigator picker label"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.sort-by-name", defaultValue: "Sort by Name", comment: "Sort by name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.sort-by-date", defaultValue: "Sort by Date", comment: "Sort by date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
