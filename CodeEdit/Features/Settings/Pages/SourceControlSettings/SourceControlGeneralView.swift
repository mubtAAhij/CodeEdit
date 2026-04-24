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
            Section(String(localized: "git.general.source-control", defaultValue: "Source Control", comment: "Source control section title")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "git.general.text-editing", defaultValue: "Text Editing", comment: "Text editing section title")) {
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
            String(localized: "git.general.refresh-local", defaultValue: "Refresh local status automatically", comment: "Refresh local status toggle"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "git.general.fetch-server", defaultValue: "Fetch and refresh server status automatically", comment: "Fetch server status toggle"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "git.general.add-remove-auto", defaultValue: "Add and remove files automatically", comment: "Add remove files automatically toggle"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "git.general.select-files-auto", defaultValue: "Select files to commit automatically", comment: "Select files to commit toggle"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "git.general.show-changes", defaultValue: "Show source control changes", comment: "Show source control changes toggle"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "git.general.include-upstream", defaultValue: "Include upstream changes", comment: "Include upstream changes toggle"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "git.general.comparison-view", defaultValue: "Comparison view", comment: "Comparison view picker"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "git.general.local-left", defaultValue: "Local Revision on Left Side", comment: "Local revision on left option"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "git.general.local-right", defaultValue: "Local Revision on Right Side", comment: "Local revision on right option"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "git.general.navigator", defaultValue: "Source control navigator", comment: "Source control navigator picker"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "git.general.sort-name", defaultValue: "Sort by Name", comment: "Sort by name option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "git.general.sort-date", defaultValue: "Sort by Date", comment: "Sort by date option"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
