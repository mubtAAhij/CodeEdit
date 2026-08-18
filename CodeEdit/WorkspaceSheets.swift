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
                    title: Text(String(localized: "workspace-sheets.discard-changes.confirmation.title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Confirmation title before discarding all local uncommitted changes.")),
                    message: Text(String(localized: "workspace-sheets.discard-changes.confirmation.message", defaultValue: "This action cannot be undone.", comment: "Confirmation message warning that discard action is irreversible.")),
                    primaryButton: .destructive(Text(String(localized: "workspace-sheets.discard-changes.confirmation.discard-button", defaultValue: "Discard", comment: "Destructive button title for confirming discard action."))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace-sheets.stage-changes.error.title", defaultValue: "Cannot Stage Changes", comment: "Error title shown when staging changes fails."), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace-sheets.alert.ok-button", defaultValue: "OK", comment: "Default confirmation button for workspace alert dialogs."), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.no-uncommitted-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when no uncommitted changes are available for requested source control action."))
            }
            .alert(String(localized: "workspace-sheets.unstage-changes.error.title", defaultValue: "Cannot Unstage Changes", comment: "Error title shown when unstaging changes fails."), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace-sheets.alert.ok-button", defaultValue: "OK", comment: "Default confirmation button for workspace alert dialogs."), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.no-uncommitted-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when no uncommitted changes are available for requested source control action."))
            }
            .alert(String(localized: "workspace-sheets.stash-changes.error.title", defaultValue: "Cannot Stash Changes", comment: "Error title shown when stashing changes fails."), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace-sheets.alert.ok-button", defaultValue: "OK", comment: "Default confirmation button for workspace alert dialogs."), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.no-uncommitted-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when no uncommitted changes are available for requested source control action."))
            }
            .alert(String(localized: "workspace-sheets.discard-changes.error.title", defaultValue: "Cannot Discard Changes", comment: "Error title shown when discarding changes fails."), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace-sheets.alert.ok-button", defaultValue: "OK", comment: "Default confirmation button for workspace alert dialogs."), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.no-uncommitted-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when no uncommitted changes are available for requested source control action."))
            }
    }
}
