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
                    title: Text(String(localized: "source_control.discard_all.title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title asking to confirm discarding all uncommitted changes")),
                    message: Text(String(localized: "source_control.discard_all.message", defaultValue: "This action cannot be undone.", comment: "Alert message warning that discard action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "source_control.discard_all.discard", defaultValue: "Discard", comment: "Button to confirm discarding all changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "source_control.cannot_stage_changes.title", defaultValue: "Cannot Stage Changes", comment: "Alert title when there are no changes to stage"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "source_control.cannot_stage_changes.ok", defaultValue: "OK", comment: "Dismiss cannot stage changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source_control.cannot_stage_changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to stage"))
            }
            .alert(String(localized: "source_control.cannot_unstage_changes.title", defaultValue: "Cannot Unstage Changes", comment: "Alert title when there are no changes to unstage"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "source_control.cannot_unstage_changes.ok", defaultValue: "OK", comment: "Dismiss cannot unstage changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source_control.cannot_unstage_changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to unstage"))
            }
            .alert(String(localized: "source_control.cannot_stash_changes.title", defaultValue: "Cannot Stash Changes", comment: "Alert title when there are no changes to stash"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "source_control.cannot_stash_changes.ok", defaultValue: "OK", comment: "Dismiss cannot stash changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source_control.cannot_stash_changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to stash"))
            }
            .alert(String(localized: "source_control.cannot_discard_changes.title", defaultValue: "Cannot Discard Changes", comment: "Alert title when there are no changes to discard"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "source_control.cannot_discard_changes.ok", defaultValue: "OK", comment: "Dismiss cannot discard changes alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source_control.cannot_discard_changes.message", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to discard"))
            }
    }
}
