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
                    title: Text(String(localized: "source-control.discard-all-changes-title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Discard all changes alert title")),
                    message: Text(String(localized: "source-control.discard-all-changes-message", defaultValue: "This action cannot be undone.", comment: "Discard all changes warning message")),
                    primaryButton: .destructive(Text(String(localized: "source-control.discard", defaultValue: "Discard", comment: "Discard button"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "source-control.cannot-stage-changes", defaultValue: "Cannot Stage Changes", comment: "Cannot stage changes alert title"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "common.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "No uncommitted changes message"))
            }
            .alert(String(localized: "source-control.cannot-unstage-changes", defaultValue: "Cannot Unstage Changes", comment: "Cannot unstage changes alert title"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "common.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "No uncommitted changes message"))
            }
            .alert(String(localized: "source-control.cannot-stash-changes", defaultValue: "Cannot Stash Changes", comment: "Cannot stash changes alert title"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "common.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "No uncommitted changes message"))
            }
            .alert(String(localized: "source-control.cannot-discard-changes", defaultValue: "Cannot Discard Changes", comment: "Cannot discard changes alert title"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "common.ok", defaultValue: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text(String(localized: "source-control.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "No uncommitted changes message"))
            }
    }
}
