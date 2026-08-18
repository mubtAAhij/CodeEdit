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
            Section(String(
                localized: "settings.source-control.general.title",
                defaultValue: "Source Control",
                comment: "Section title for source control general settings"
            )) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(
                localized: "settings.source-control.general.text-editing.section-title",
                defaultValue: "Text Editing",
                comment: "Subsection title for text editing related source control behavior"
            )) {
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
            String(
                localized: "settings.source-control.general.refresh-local-status-automatically",
                defaultValue: "Refresh local status automatically",
                comment: "Toggle label for automatically refreshing local source control status"
            ),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(
                localized: "settings.source-control.general.fetch-and-refresh-server-status-automatically",
                defaultValue: "Fetch and refresh server status automatically",
                comment: "Toggle label for automatically fetching and refreshing remote source control status"
            ),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(
                localized: "settings.source-control.general.add-and-remove-files-automatically",
                defaultValue: "Add and remove files automatically",
                comment: "Toggle label for automatically tracking file additions and deletions"
            ),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(
                localized: "settings.source-control.general.select-files-to-commit-automatically",
                defaultValue: "Select files to commit automatically",
                comment: "Toggle label for automatically selecting files for commit"
            ),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(
                localized: "settings.source-control.general.show-source-control-changes",
                defaultValue: "Show source control changes",
                comment: "Toggle label for showing inline source control changes in editor"
            ),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(
                localized: "settings.source-control.general.include-upstream-changes",
                defaultValue: "Include upstream changes",
                comment: "Toggle label for including upstream changes in source control indicators"
            ),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(
                localized: "settings.source-control.general.comparison-view.section-title",
                defaultValue: "Comparison view",
                comment: "Section title for source control comparison view settings"
            ),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(
                localized: "settings.source-control.general.local-revision-on-left-side",
                defaultValue: "Local Revision on Left Side",
                comment: "Option label for displaying local revision on left side in comparison view"
            ))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(
                localized: "settings.source-control.general.local-revision-on-right-side",
                defaultValue: "Local Revision on Right Side",
                comment: "Option label for displaying local revision on right side in comparison view"
            ))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(
                localized: "settings.source-control.general.navigator.section-title",
                defaultValue: "Source control navigator",
                comment: "Section title for source control navigator settings"
            ),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(
                localized: "settings.source-control.general.navigator.sort-by-name",
                defaultValue: "Sort by Name",
                comment: "Option label for sorting source control navigator entries by name"
            ))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(
                localized: "settings.source-control.general.navigator.sort-by-date",
                defaultValue: "Sort by Date",
                comment: "Option label for sorting source control navigator entries by date"
            ))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
