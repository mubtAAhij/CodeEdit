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
            Section(String(localized: "settings.source_control.section.source_control", defaultValue: "Source Control", comment: "Source Control settings section title")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source_control.section.text_editing", defaultValue: "Text Editing", comment: "Text Editing settings section title")) {
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
            String(localized: "settings.source_control.refresh_local_status_automatically", defaultValue: "Refresh local status automatically", comment: "Toggle to refresh local status automatically"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source_control.fetch_refresh_server_status_automatically", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle to fetch and refresh server status automatically"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source_control.add_remove_files_automatically", defaultValue: "Add and remove files automatically", comment: "Toggle to add and remove files automatically"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source_control.select_files_to_commit_automatically", defaultValue: "Select files to commit automatically", comment: "Toggle to select files to commit automatically"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source_control.show_source_control_changes", defaultValue: "Show source control changes", comment: "Toggle to show source control changes"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source_control.include_upstream_changes", defaultValue: "Include upstream changes", comment: "Toggle to include upstream changes"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source_control.comparison_view", defaultValue: "Comparison view", comment: "Picker label for comparison view"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source_control.comparison_view.local_revision_on_left_side", defaultValue: "Local Revision on Left Side", comment: "Comparison view option for local revision on left side"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source_control.comparison_view.local_revision_on_right_side", defaultValue: "Local Revision on Right Side", comment: "Comparison view option for local revision on right side"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source_control.source_control_navigator", defaultValue: "Source control navigator", comment: "Picker label for source control navigator"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source_control.source_control_navigator.sort_by_name", defaultValue: "Sort by Name", comment: "Source control navigator option to sort by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source_control.source_control_navigator.sort_by_date", defaultValue: "Sort by Date", comment: "Source control navigator option to sort by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
