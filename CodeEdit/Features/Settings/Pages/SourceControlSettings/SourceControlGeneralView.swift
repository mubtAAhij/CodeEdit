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
            Section(String(localized: "source_control", comment: "Section header for source control settings")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section("Text Editing") {
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
            "Refresh local status automatically",
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            "Fetch and refresh server status automatically",
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            "Add and remove files automatically",
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "select_files_commit_automatically", comment: "Toggle label for automatically selecting files to commit"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "show_source_control_changes", comment: "Toggle label for showing source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "include_upstream_changes", comment: "Toggle label for including upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "comparison_view", comment: "Picker label for comparison view settings"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "local_revision_left_side", comment: "Option for showing local revision on the left side in comparison view"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "local_revision_on_right_side", comment: "Option for comparison view layout"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            "Source control navigator",
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "sort_by_name", comment: "Option for source control navigator sorting"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "sort_by_date", comment: "Option for source control navigator sorting"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
