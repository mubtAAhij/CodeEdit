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
            Section(String(localized: "settings.source-control.section.source-control", defaultValue: "Source Control", comment: "Section header for source control settings")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.section.text-editing", defaultValue: "Text Editing", comment: "Section header for text editing options in source control")) {
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
            String(localized: "settings.source-control.refresh-local-status-auto", defaultValue: "Refresh local status automatically", comment: "Toggle to enable automatic refresh of local status"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.fetch-refresh-server-auto", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle to enable automatic fetch and refresh of server status"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.add-remove-files-auto", defaultValue: "Add and remove files automatically", comment: "Toggle to enable automatic addition and removal of files"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.select-files-to-commit-auto", defaultValue: "Select files to commit automatically", comment: "Toggle to enable automatic selection of files to commit"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.show-source-control-changes", defaultValue: "Show source control changes", comment: "Toggle to show source control changes"),
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
            String(localized: "settings.source-control.comparison-view", defaultValue: "Comparison view", comment: "Picker label for comparison view layout"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.comparison-view.local-left", defaultValue: "Local Revision on Left Side", comment: "Option to show local revision on left side"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.comparison-view.local-right", defaultValue: "Local Revision on Right Side", comment: "Option to show local revision on right side"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.navigator", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sorting"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.navigator.sort-by-name", defaultValue: "Sort by Name", comment: "Option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.navigator.sort-by-date", defaultValue: "Sort by Date", comment: "Option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
