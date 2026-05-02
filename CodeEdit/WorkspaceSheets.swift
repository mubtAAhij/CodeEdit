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
                    title: Text(String(localized: "workspace.discard.all.title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title asking to confirm discarding all uncommitted changes")),
                    message: Text(String(localized: "workspace.action.cannot.be.undone", defaultValue: "This action cannot be undone.", comment: "Warning that an action is permanent and cannot be reversed")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard.button", defaultValue: "Discard", comment: "Button to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.cannot.stage.changes", defaultValue: "Cannot Stage Changes", comment: "Alert title when there are no changes to stage"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.ok.button", defaultValue: "OK", comment: "OK button to dismiss alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no.uncommitted.changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
            .alert(String(localized: "workspace.cannot.unstage.changes", defaultValue: "Cannot Unstage Changes", comment: "Alert title when there are no changes to unstage"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.ok.button.unstage", defaultValue: "OK", comment: "OK button to dismiss unstage alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no.uncommitted.changes.unstage", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to unstage"))
            }
            .alert(String(localized: "workspace.cannot.stash.changes", defaultValue: "Cannot Stash Changes", comment: "Alert title when there are no changes to stash"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.ok.button.stash", defaultValue: "OK", comment: "OK button to dismiss stash alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no.uncommitted.changes.stash", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to stash"))
            }
            .alert(String(localized: "workspace.cannot.discard.changes", defaultValue: "Cannot Discard Changes", comment: "Alert title when there are no changes to discard"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.ok.button.discard", defaultValue: "OK", comment: "OK button to dismiss discard alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no.uncommitted.changes.discard", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to discard"))
            }
    }
}
