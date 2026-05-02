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
            Section(String(localized: "source.control.settings.section", defaultValue: "Source Control", comment: "Source control settings section header")) {
                refreshLocalStatusAuto
                fetchRefreshStatusAuto
                addRemoveFilesAuto
                selectFilesToCommitAuto
            }
            Section(String(localized: "source.control.text.editing.section", defaultValue: "Text Editing", comment: "Text editing settings section header")) {
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
            String(localized: "source.control.refresh.local.status", defaultValue: "Refresh local status automatically", comment: "Toggle to automatically refresh local repository status"),
            isOn: $settings.refreshStatusLocally
        )
    }

    private var fetchRefreshStatusAuto: some View {
        Toggle(
            String(localized: "source.control.fetch.refresh.server.status", defaultValue: "Fetch and refresh server status automatically", comment: "Toggle to automatically fetch and refresh server status"),
            isOn: $settings.fetchRefreshServerStatus
        )
    }

    private var addRemoveFilesAuto: some View {
        Toggle(
            String(localized: "source.control.add.remove.files", defaultValue: "Add and remove files automatically", comment: "Toggle to automatically add and remove files in source control"),
            isOn: $settings.addRemoveAutomatically
        )
    }

    private var selectFilesToCommitAuto: some View {
        Toggle(
            String(localized: "source.control.select.files.commit", defaultValue: "Select files to commit automatically", comment: "Toggle to automatically select files to commit"),
            isOn: $settings.selectFilesToCommit
        )
    }

    private var showSourceControlChanges: some View {
        Toggle(
            String(localized: "source.control.show.changes", defaultValue: "Show source control changes", comment: "Toggle to show source control changes in editor"),
            isOn: $settings.showSourceControlChanges
        )
    }

    private var includeUpstreamChanges: some View {
        Toggle(
            String(localized: "source.control.include.upstream.changes", defaultValue: "Include upstream changes", comment: "Toggle to include upstream changes in diff view"),
            isOn: $settings.includeUpstreamChanges
        )
        .disabled(!settings.showSourceControlChanges)
    }

    private var comparisonView: some View {
        Picker(
            String(localized: "source.control.comparison.view", defaultValue: "Comparison view", comment: "Picker label for revision comparison layout"),
            selection: $settings.revisionComparisonLayout
        ) {
            Text(String(localized: "source.control.local.revision.left", defaultValue: "Local Revision on Left Side", comment: "Option to show local revision on the left side in comparison view"))
                .tag(SettingsData.RevisionComparisonLayout.localLeft)
            Text(String(localized: "source.control.local.revision.right", defaultValue: "Local Revision on Right Side", comment: "Option to show local revision on the right side in comparison view"))
                .tag(SettingsData.RevisionComparisonLayout.localRight)
        }
    }

    private var sourceControlNavigator: some View {
        Picker(
            String(localized: "source.control.navigator", defaultValue: "Source control navigator", comment: "Picker label for source control navigator sort order"),
            selection: $settings.controlNavigatorOrder
        ) {
            Text(String(localized: "source.control.sort.by.name", defaultValue: "Sort by Name", comment: "Option to sort source control navigator by name"))
                .tag(SettingsData.ControlNavigatorOrder.sortByName)
            Text(String(localized: "source.control.sort.by.date", defaultValue: "Sort by Date", comment: "Option to sort source control navigator by date"))
                .tag(SettingsData.ControlNavigatorOrder.sortByDate)
        }
    }
}
