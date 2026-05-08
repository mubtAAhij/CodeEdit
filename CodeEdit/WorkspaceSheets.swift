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
                    title: Text(String(localized: "source-control.discard-all-title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Alert title for discarding all changes")),
                    message: Text(String(localized: "source-control.discard-warning", defaultValue: "This action cannot be undone.", comment: "Warning that discard action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "source-control.discard-button", defaultValue: "Discard", comment: "Button to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "source-control.cannot-stage", defaultValue: "Cannot Stage Changes", comment: "Alert title when unable to stage changes"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "source-control.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes"))
            }
            .alert(String(localized: "source-control.cannot-unstage", defaultValue: "Cannot Unstage Changes", comment: "Alert title when unable to unstage changes"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "source-control.ok-unstage", defaultValue: "OK", comment: "OK button for unstage alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes-unstage", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to unstage"))
            }
            .alert(String(localized: "source-control.cannot-stash", defaultValue: "Cannot Stash Changes", comment: "Alert title when unable to stash changes"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "source-control.ok-stash", defaultValue: "OK", comment: "OK button for stash alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes-stash", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to stash"))
            }
            .alert(String(localized: "source-control.cannot-discard", defaultValue: "Cannot Discard Changes", comment: "Alert title when unable to discard changes"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "source-control.ok-discard", defaultValue: "OK", comment: "OK button for discard alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes-discard", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message when there are no uncommitted changes to discard"))
            }
    }
}
