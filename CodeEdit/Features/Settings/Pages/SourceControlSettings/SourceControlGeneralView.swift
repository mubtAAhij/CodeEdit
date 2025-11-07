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
                localized: "settings.source-control.section-title",
                defaultValue: "Source Control",
                comment: "Section title for source control settings"
            )) {
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
            "Select files to commit automatically",
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            "Show source control changes",
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            "Include upstream changes",
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            "Comparison view",
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(
                localized: "settings.source-control.local-left",
                defaultValue: "Local Revision on Left Side",
                comment: "Option to show local revision on left side in comparison view"
            ))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(
                localized: "settings.source-control.local-right",
                defaultValue: "Local Revision on Right Side",
                comment: "Option to show local revision on right side in comparison view"
            ))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            "Source control navigator",
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(
                localized: "settings.source-control.sort-by-name",
                defaultValue: "Sort by Name",
                comment: "Option to sort source control navigator by name"
            ))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(
                localized: "settings.source-control.sort-by-date",
                defaultValue: "Sort by Date",
                comment: "Option to sort source control navigator by date"
            ))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
