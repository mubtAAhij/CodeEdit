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
            Section(String(localized: "source-control", defaultValue: "Source Control", comment: "Source Control section")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "text-editing", defaultValue: "Text Editing", comment: "Text Editing section")) {
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
            String(localized: "source-control.refresh-local-status-automatically", defaultValue: "Refresh local status automatically", comment: "Refresh local status automatically toggle"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "source-control.fetch-and-refresh-server-status-automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Fetch and refresh server status automatically toggle"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "source-control.add-and-remove-files-automatically", defaultValue: "Add and remove files automatically", comment: "Add and remove files automatically toggle"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "source-control.select-files-to-commit-automatically", defaultValue: "Select files to commit automatically", comment: "Select files to commit automatically toggle"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "source-control.show-source-control-changes", defaultValue: "Show source control changes", comment: "Show source control changes toggle"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "source-control.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Include upstream changes toggle"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "source-control.comparison-view", defaultValue: "Comparison view", comment: "Comparison view picker"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "source-control.local-revision-on-left-side", defaultValue: "Local Revision on Left Side", comment: "Local Revision on Left Side option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "source-control.local-revision-on-right-side", defaultValue: "Local Revision on Right Side", comment: "Local Revision on Right Side option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "source-control.source-control-navigator", defaultValue: "Source control navigator", comment: "Source control navigator picker"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "source-control.sort-by-name", defaultValue: "Sort by Name", comment: "Sort by Name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "source-control.sort-by-date", defaultValue: "Sort by Date", comment: "Sort by Date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
