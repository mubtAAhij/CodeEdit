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
            Section(String(localized: "settings.source-control.general.title", defaultValue: "Source Control", comment: "Section title for source control general settings.")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "settings.source-control.general.text-editing.section-title", defaultValue: "Text Editing", comment: "Section title for source control text editing settings.")) {
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
            String(localized: "settings.source-control.general.refresh-local-status-automatically.toggle", defaultValue: "Refresh local status automatically", comment: "Toggle to automatically refresh local source control status."),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.fetch-refresh-server-status-automatically.toggle", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle to automatically fetch and refresh remote source control status."),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.add-remove-files-automatically.toggle", defaultValue: "Add and remove files automatically", comment: "Toggle to automatically stage file add and remove operations."),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "settings.source-control.general.select-files-to-commit-automatically.toggle", defaultValue: "Select files to commit automatically", comment: "Toggle to automatically select files for commit."),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "settings.source-control.general.show-source-control-changes.toggle", defaultValue: "Show source control changes", comment: "Toggle to display source control changes in editor."),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "settings.source-control.general.include-upstream-changes.toggle", defaultValue: "Include upstream changes", comment: "Toggle to include upstream changes in comparison."),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "settings.source-control.general.comparison-view.label", defaultValue: "Comparison view", comment: "Label for selecting source control comparison view orientation."),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "settings.source-control.general.comparison-view.local-revision-left.option", defaultValue: "Local Revision on Left Side", comment: "Option to place local revision on left side in comparison view."))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "settings.source-control.general.comparison-view.local-revision-right.option", defaultValue: "Local Revision on Right Side", comment: "Option to place local revision on right side in comparison view."))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "settings.source-control.general.navigator.section-title", defaultValue: "Source control navigator", comment: "Section title for source control navigator settings."),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "settings.source-control.general.navigator.sort-by-name.option", defaultValue: "Sort by Name", comment: "Sort option for source control navigator by name."))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "settings.source-control.general.navigator.sort-by-date.option", defaultValue: "Sort by Date", comment: "Sort option for source control navigator by date."))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
