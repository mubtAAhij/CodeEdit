//
//  WorkspaceSheets.swift
//  CodeEdit
//
//  Created by Austin Condiff on 7/1/24.
//

import SwiftUI

struct WorkspaceSheets: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager

    var body: some View {
        EmptyView()
            .sheet(isPresented: Binding<Bool>(
                get: { sourceControlManager.pushSheetIsPresented &&
                       !sourceControlManager.addExistingRemoteSheetIsPresented },
                set: { sourceControlManager.pushSheetIsPresented = $0 }
            )) {
                SourceControlPushView()
            }
            .sheet(isPresented: Binding<Bool>(
                get: { sourceControlManager.pullSheetIsPresented &&
                       !sourceControlManager.addExistingRemoteSheetIsPresented &&
                       !sourceControlManager.stashSheetIsPresented },
                set: { sourceControlManager.pullSheetIsPresented = $0 }
            )) {
                if sourceControlManager.addExistingRemoteSheetIsPresented == true {
                    SourceControlAddExistingRemoteView()
                } else {
                    SourceControlPullView()
                }
            }
            .sheet(isPresented: $sourceControlManager.fetchSheetIsPresented) {
                SourceControlFetchView()
            }
            .sheet(isPresented: $sourceControlManager.stashSheetIsPresented) {
                SourceControlStashView()
            }
            .sheet(isPresented: $sourceControlManager.addExistingRemoteSheetIsPresented) {
                SourceControlAddExistingRemoteView()
            }
            .sheet(item: Binding<GitBranch?>(
                get: {
                    sourceControlManager.switchToBranch != nil
                    && sourceControlManager.stashSheetIsPresented
                    ? nil
                    : sourceControlManager.switchToBranch
                },
                set: { sourceControlManager.switchToBranch = $0 }
            )) { branch in
                SourceControlSwitchView(branch: branch)
            }
            .alert(isPresented: $sourceControlManager.discardAllAlertIsPresented) {
                Alert(
                    title: Text(String(localized: "workspace.discard_changes.confirmation", comment: "Confirmation dialog asking if user wants to discard uncommitted changes")),
                    message: Text(String(localized: "workspace.discard_changes.warning", comment: "Warning that the discard action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard_changes.action", comment: "Button text to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.stage_changes.error_title", comment: "Error dialog title when staging changes fails"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "common.ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes", comment: "Message when there are no uncommitted changes in the repository"))
            }
            .alert(String(localized: "workspace.unstage_changes.error_title", comment: "Error dialog title when unstaging changes fails"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "common.ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes", comment: "Message when there are no uncommitted changes in the repository"))
            }
            .alert(String(localized: "workspace.stash_changes.error_title", comment: "Error dialog title when stashing changes fails"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "common.ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes", comment: "Message when there are no uncommitted changes in the repository"))
            }
            .alert(String(localized: "workspace.discard_changes.error_title", comment: "Error dialog title when discarding changes fails"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "common.ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes", comment: "Message when there are no uncommitted changes in the repository"))
            }
    }
}
