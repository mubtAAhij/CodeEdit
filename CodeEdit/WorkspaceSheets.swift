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
                    title: Text(String(localized: "workspace.sheet.discard-local-changes.confirmation-message", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Confirmation message asking whether to discard all uncommitted local changes")),
                    message: Text(String(localized: "workspace.sheet.discard-local-changes.warning", defaultValue: "This action cannot be undone.", comment: "Warning text indicating the discard action is irreversible")),
                    primaryButton: .destructive(Text(String(localized: "workspace.sheet.discard-local-changes.discard-button", defaultValue: "Discard", comment: "Destructive button title to discard local changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.sheet.stage-changes.error-title", defaultValue: "Cannot Stage Changes", comment: "Error alert title when staging changes fails"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.sheet.stage-changes.ok-button", defaultValue: "OK", comment: "Acknowledgement button title for stage changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheet.stage-changes.no-uncommitted-changes-message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Informational message shown when there are no local uncommitted changes to stage"))
            }
            .alert(String(localized: "workspace.sheet.unstage-changes.error-title", defaultValue: "Cannot Unstage Changes", comment: "Error alert title when unstaging changes fails"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.sheet.unstage-changes.ok-button", defaultValue: "OK", comment: "Acknowledgement button title for unstage changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheet.unstage-changes.no-uncommitted-changes-message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Informational message shown when there are no local uncommitted changes to unstage"))
            }
            .alert(String(localized: "workspace.sheet.stash-changes.error-title", defaultValue: "Cannot Stash Changes", comment: "Error alert title when stashing changes fails"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.sheet.stash-changes.ok-button", defaultValue: "OK", comment: "Acknowledgement button title for stash changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheet.stash-changes.no-uncommitted-changes-message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Informational message shown when there are no local uncommitted changes to stash"))
            }
            .alert(String(localized: "workspace.sheet.discard-changes.error-title", defaultValue: "Cannot Discard Changes", comment: "Error alert title when discarding changes fails"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.sheet.discard-changes.ok-button", defaultValue: "OK", comment: "Acknowledgement button title for discard changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.sheet.discard-changes.no-uncommitted-changes-message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Informational message shown when there are no local uncommitted changes to discard"))
            }
    }
}
