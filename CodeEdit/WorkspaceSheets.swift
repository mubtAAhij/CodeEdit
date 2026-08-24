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
                    title: Text(String(localized: "workspace.sheets.discard-changes.confirmation", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Confirmation prompt before discarding all local uncommitted changes")),
                    message: Text(String(localized: "workspace.sheets.discard-changes.cannot-be-undone", defaultValue: "This action cannot be undone.", comment: "Warning text shown in discard changes confirmation dialog")),
                    primaryButton: .destructive(Text(String(localized: "workspace.sheets.discard-changes.discard", defaultValue: "Discard", comment: "Button title to confirm discarding local changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.sheets.stage-changes.error-title", defaultValue: "Cannot Stage Changes", comment: "Alert title when staging changes fails"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.sheets.stage-changes.ok", defaultValue: "OK", comment: "Default acknowledgement button title in stage changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheets.stage-changes.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no changes available to stage"))
            }
            .alert(String(localized: "workspace.sheets.unstage-changes.error-title", defaultValue: "Cannot Unstage Changes", comment: "Alert title when unstaging changes fails"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.sheets.unstage-changes.ok", defaultValue: "OK", comment: "Default acknowledgement button title in unstage changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheets.unstage-changes.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no changes available to unstage"))
            }
            .alert(String(localized: "workspace.sheets.stash-changes.error-title", defaultValue: "Cannot Stash Changes", comment: "Alert title when stashing changes fails"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.sheets.stash-changes.ok", defaultValue: "OK", comment: "Default acknowledgement button title in stash changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheets.stash-changes.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no changes available to stash"))
            }
            .alert(String(localized: "workspace.sheets.discard-changes.error-title", defaultValue: "Cannot Discard Changes", comment: "Alert title when discarding changes fails"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.sheets.discard-changes.ok", defaultValue: "OK", comment: "Default acknowledgement button title in discard changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheets.discard-changes.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no changes available to discard"))
            }
    }
}
