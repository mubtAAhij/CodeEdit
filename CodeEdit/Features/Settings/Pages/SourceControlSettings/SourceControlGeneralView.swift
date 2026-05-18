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
            Section(String(localized: "source-control.settings.section-title", defaultValue: "Source Control", comment: "Section header for source control settings")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "source-control.settings.text-editing-section", defaultValue: "Text Editing", comment: "Section header for text editing settings")) {
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
            String(localized: "source-control.settings.refresh-local-status", defaultValue: "Refresh local status automatically", comment: "Toggle label for automatically refreshing local status"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "source-control.settings.fetch-refresh-server-status", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle label for automatically fetching and refreshing server status"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "source-control.settings.add-remove-files-auto", defaultValue: "Add and remove files automatically", comment: "Toggle label for automatically adding and removing files"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "source-control.settings.select-files-to-commit-auto", defaultValue: "Select files to commit automatically", comment: "Toggle label for automatically selecting files to commit"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "source-control.settings.show-source-control-changes", defaultValue: "Show source control changes", comment: "Toggle label for showing source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "source-control.settings.include-upstream-changes", defaultValue: "Include upstream changes", comment: "Toggle label for including upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "source-control.settings.comparison-view", defaultValue: "Comparison view", comment: "Picker label for comparison view layout"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "source-control.settings.local-revision-left", defaultValue: "Local Revision on Left Side", comment: "Option for local revision on left side"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "source-control.settings.local-revision-right", defaultValue: "Local Revision on Right Side", comment: "Option for local revision on right side"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "source-control.settings.navigator-label", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sort order"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "source-control.settings.sort-by-name", defaultValue: "Sort by Name", comment: "Option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "source-control.settings.sort-by-date", defaultValue: "Sort by Date", comment: "Option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
