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
            Section(String(localized: "settings.source-control.section", defaultValue: "Source Control", comment: "Source control settings section title")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.text-editing", defaultValue: "Text Editing", comment: "Text editing settings section title")) {
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
            String(localized: "settings.source-control.refresh-local", defaultValue: "Refresh local status automatically", comment: "Toggle for automatically refreshing local status"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.fetch-refresh-server", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle for automatically fetching and refreshing server status"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.add-remove-files", defaultValue: "Add and remove files automatically", comment: "Toggle for automatically adding and removing files"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.select-files-commit", defaultValue: "Select files to commit automatically", comment: "Toggle for automatically selecting files to commit"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.show-changes", defaultValue: "Show source control changes", comment: "Toggle for showing source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.include-upstream", defaultValue: "Include upstream changes", comment: "Toggle for including upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.comparison-view", defaultValue: "Comparison view", comment: "Picker label for comparison view layout"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.local-left", defaultValue: "Local Revision on Left Side", comment: "Option for local revision on left side"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.local-right", defaultValue: "Local Revision on Right Side", comment: "Option for local revision on right side"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.navigator", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sort order"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.sort-name", defaultValue: "Sort by Name", comment: "Option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.sort-date", defaultValue: "Sort by Date", comment: "Option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
