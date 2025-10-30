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
                    title: Text(String(localized: "workspace.discard-all.title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title to confirm discarding all changes")),
                    message: Text(String(localized: "workspace.discard-all.message", defaultValue: "This action cannot be undone.", comment: "Warning that discard action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard-all.discard", defaultValue: "Discard", comment: "Discard button in alert"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.no-changes.stage-title", defaultValue: "Cannot Stage Changes", comment: "Alert title when no changes to stage"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.no-changes.ok", defaultValue: "OK", comment: "OK button in alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
            .alert(String(localized: "workspace.no-changes.unstage-title", defaultValue: "Cannot Unstage Changes", comment: "Alert title when no changes to unstage"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.no-changes.ok", defaultValue: "OK", comment: "OK button in alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
            .alert(String(localized: "workspace.no-changes.stash-title", defaultValue: "Cannot Stash Changes", comment: "Alert title when no changes to stash"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.no-changes.ok", defaultValue: "OK", comment: "OK button in alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
            .alert(String(localized: "workspace.no-changes.discard-title", defaultValue: "Cannot Discard Changes", comment: "Alert title when no changes to discard"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.no-changes.ok", defaultValue: "OK", comment: "OK button in alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no-changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
    }
}
