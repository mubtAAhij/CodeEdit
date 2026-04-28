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
            Section(String(localized: "source-control.section", defaultValue: "Source Control", comment: "Source control section header")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "source-control.text-editing", defaultValue: "Text Editing", comment: "Text editing section header")) {
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
            String(localized: "source-control.refresh-local-status", defaultValue: "Refresh local status automatically", comment: "Toggle for automatic local status refresh"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "source-control.fetch-refresh-server-status", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle for automatic server status fetch and refresh"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "source-control.add-remove-files", defaultValue: "Add and remove files automatically", comment: "Toggle for automatic file addition and removal"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "source-control.select-files-to-commit", defaultValue: "Select files to commit automatically", comment: "Toggle for automatic file selection for commits"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "source-control.show-changes", defaultValue: "Show source control changes", comment: "Toggle for showing source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "source-control.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Toggle for including upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "source-control.comparison-view", defaultValue: "Comparison view", comment: "Label for comparison view picker"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "source-control.comparison-view.local-left", defaultValue: "Local Revision on Left Side", comment: "Option for local revision on left side"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "source-control.comparison-view.local-right", defaultValue: "Local Revision on Right Side", comment: "Option for local revision on right side"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "source-control.navigator", defaultValue: "Source control navigator", comment: "Label for source control navigator picker"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "source-control.navigator.sort-by-name", defaultValue: "Sort by Name", comment: "Option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "source-control.navigator.sort-by-date", defaultValue: "Sort by Date", comment: "Option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
