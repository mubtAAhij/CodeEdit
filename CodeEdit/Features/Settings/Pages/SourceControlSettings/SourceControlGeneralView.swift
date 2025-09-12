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
            "String(localized: "select_files_commit_automatically", comment: "Toggle to automatically select files for commit")",
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            "String(localized: "show_source_control_changes", comment: "Toggle to display source control changes in the editor")",
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            "String(localized: "include_upstream_changes", comment: "Toggle to include upstream changes in source control display")",
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            "String(localized: "comparison_view", comment: "Picker label for revision comparison layout options")",
            selection: $settings.revisionComparisonLayout
        ) {
            Text("String(localized: "local_revision_left_side", comment: "Option to show local revision on the left side in comparison view")")
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text("String(localized: "local_revision_right_side", comment: "Option to show local revision on the right side in comparison view")")
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            "Source control navigator",
            selection: $settings.controlNavigatorOrder
        ) {
            Text("String(localized: "sort_by_name", comment: "Option to sort source control navigator items by name")")
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text("String(localized: "sort_by_date", comment: "Option to sort source control navigator items by date")")
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
