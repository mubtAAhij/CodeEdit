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
            Section(String(localized: "settings.source-control.section.source-control", defaultValue: "Source Control", comment: "Source Control section header in settings")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.section.text-editing", defaultValue: "Text Editing", comment: "Text Editing section header in source control settings")) {
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
            String(localized: "settings.source-control.show-changes", defaultValue: "Show source control changes", comment: "Toggle to show source control changes in text editing"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Toggle to include upstream changes in source control"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.comparison-view", defaultValue: "Comparison view", comment: "Picker label for revision comparison view setting"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.comparison-view.local-left", defaultValue: "Local Revision on Left Side", comment: "Comparison view option for local revision on left"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.comparison-view.local-right", defaultValue: "Local Revision on Right Side", comment: "Comparison view option for local revision on right"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.navigator-order", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sort order"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.navigator-order.sort-by-name", defaultValue: "Sort by Name", comment: "Navigator order option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.navigator-order.sort-by-date", defaultValue: "Sort by Date", comment: "Navigator order option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
