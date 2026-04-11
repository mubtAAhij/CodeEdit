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
            Section(String(localized: "source-control-general.section-source-control", defaultValue: "Source Control", comment: "Source control section header")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "source-control-general.section-text-editing", defaultValue: "Text Editing", comment: "Text editing section header")) {
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
            String(localized: "source-control-general.refresh-local-status", defaultValue: "Refresh local status automatically", comment: "Refresh local status automatically toggle"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "source-control-general.fetch-refresh-server", defaultValue: "Fetch and refresh server status automatically", comment: "Fetch and refresh server status automatically toggle"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "source-control-general.add-remove-files", defaultValue: "Add and remove files automatically", comment: "Add and remove files automatically toggle"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "source-control-general.select-files-to-commit", defaultValue: "Select files to commit automatically", comment: "Select files to commit automatically toggle"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "source-control-general.show-changes", defaultValue: "Show source control changes", comment: "Show source control changes toggle"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "source-control-general.include-upstream", defaultValue: "Include upstream changes", comment: "Include upstream changes toggle"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "source-control-general.comparison-view", defaultValue: "Comparison view", comment: "Comparison view picker label"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "source-control-general.local-left", defaultValue: "Local Revision on Left Side", comment: "Local revision on left side option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "source-control-general.local-right", defaultValue: "Local Revision on Right Side", comment: "Local revision on right side option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "source-control-general.navigator", defaultValue: "Source control navigator", comment: "Source control navigator picker label"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "source-control-general.sort-by-name", defaultValue: "Sort by Name", comment: "Sort by name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "source-control-general.sort-by-date", defaultValue: "Sort by Date", comment: "Sort by date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
