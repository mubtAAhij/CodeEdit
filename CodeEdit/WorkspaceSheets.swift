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
                    title: Text(String(localized: "workspace.discard-all-title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title asking to confirm discarding all changes")),
                    message: Text(String(localized: "workspace.discard-warning", defaultValue: "This action cannot be undone.", comment: "Warning that discard action is irreversible")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard-button", defaultValue: "Discard", comment: "Button to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.cannot-stage", defaultValue: "Cannot Stage Changes", comment: "Alert title when staging is not possible"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes-message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message explaining no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.cannot-unstage", defaultValue: "Cannot Unstage Changes", comment: "Alert title when unstaging is not possible"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.ok-unstage", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes-message-unstage", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message explaining no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.cannot-stash", defaultValue: "Cannot Stash Changes", comment: "Alert title when stashing is not possible"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.ok-stash", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes-message-stash", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message explaining no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.cannot-discard", defaultValue: "Cannot Discard Changes", comment: "Alert title when discarding is not possible"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.ok-discard", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes-message-discard", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message explaining no uncommitted changes exist"))
            }
    }
}
