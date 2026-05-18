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
                    title: Text(String(localized: "workspace.source-control.discard-all-alert-title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title asking to confirm discarding all uncommitted changes")),
                    message: Text(String(localized: "workspace.source-control.discard-all-alert-message", defaultValue: "This action cannot be undone.", comment: "Alert message warning that discard action is permanent")),
                    primaryButton: .destructive(Text(String(localized: "workspace.source-control.discard", defaultValue: "Discard", comment: "Button to confirm discarding changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.source-control.cannot-stage-changes", defaultValue: "Cannot Stage Changes", comment: "Alert title when there are no changes to stage"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace.source-control.ok", defaultValue: "OK", comment: "Button to dismiss alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no uncommitted changes"))
            }
            .alert(String(localized: "workspace.source-control.cannot-unstage-changes", defaultValue: "Cannot Unstage Changes", comment: "Alert title when there are no changes to unstage"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace.source-control.ok-unstage", defaultValue: "OK", comment: "Button to dismiss unstage alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.source-control.no-uncommitted-changes-unstage", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to unstage"))
            }
            .alert(String(localized: "workspace.source-control.cannot-stash-changes", defaultValue: "Cannot Stash Changes", comment: "Alert title when there are no changes to stash"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace.source-control.ok-stash", defaultValue: "OK", comment: "Button to dismiss stash alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.source-control.no-uncommitted-changes-stash", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to stash"))
            }
            .alert(String(localized: "workspace.source-control.cannot-discard-changes", defaultValue: "Cannot Discard Changes", comment: "Alert title when there are no changes to discard"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace.source-control.ok-discard", defaultValue: "OK", comment: "Button to dismiss discard alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.source-control.no-uncommitted-changes-discard", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to discard"))
            }
    }
}
