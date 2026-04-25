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
            Section(String(localized: "settings.source-control.general.section-title", defaultValue: "Source Control", comment: "Source Control section title")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.general.text-editing", defaultValue: "Text Editing", comment: "Text Editing section title")) {
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
            String(localized: "settings.source-control.general.refresh-local", defaultValue: "Refresh local status automatically", comment: "Toggle for refreshing local status automatically"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.fetch-server", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle for fetching and refreshing server status automatically"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.add-remove-files", defaultValue: "Add and remove files automatically", comment: "Toggle for adding and removing files automatically"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.select-files", defaultValue: "Select files to commit automatically", comment: "Toggle for selecting files to commit automatically"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.general.show-changes", defaultValue: "Show source control changes", comment: "Toggle for showing source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.general.include-upstream", defaultValue: "Include upstream changes", comment: "Toggle for including upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.general.comparison-view", defaultValue: "Comparison view", comment: "Picker label for comparison view layout"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.general.comparison.local-left", defaultValue: "Local Revision on Left Side", comment: "Local revision on left side option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.general.comparison.local-right", defaultValue: "Local Revision on Right Side", comment: "Local revision on right side option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.general.navigator", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sort order"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.general.navigator.sort-name", defaultValue: "Sort by Name", comment: "Sort by name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.general.navigator.sort-date", defaultValue: "Sort by Date", comment: "Sort by date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
