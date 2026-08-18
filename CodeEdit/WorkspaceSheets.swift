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
                    title: Text(String(localized: "workspace-sheets.source-control.discard-confirmation.title", defaultValue: "Do you want to discard all uncommitted, local changes?", comment: "Confirmation title before discarding all local uncommitted changes")),
                    message: Text(String(localized: "workspace-sheets.source-control.discard-confirmation.message", defaultValue: "This action cannot be undone.", comment: "Warning message for destructive source control discard action")),
                    primaryButton: .destructive(Text(String(localized: "workspace-sheets.source-control.discard-confirmation.discard", defaultValue: "Discard", comment: "Destructive button label in discard confirmation alert"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace-sheets.source-control.stage-error.title", defaultValue: "Cannot Stage Changes", comment: "Alert title when stage all changes operation cannot proceed"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspace-sheets.source-control.stage-error.ok", defaultValue: "OK", comment: "Acknowledgement button for stage changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.source-control.stage-error.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no local uncommitted changes to stage"))
            }
            .alert(String(localized: "workspace-sheets.source-control.unstage-error.title", defaultValue: "Cannot Unstage Changes", comment: "Alert title when unstage all changes operation cannot proceed"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspace-sheets.source-control.unstage-error.ok", defaultValue: "OK", comment: "Acknowledgement button for unstage changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.source-control.unstage-error.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no local uncommitted changes to unstage"))
            }
            .alert(String(localized: "workspace-sheets.source-control.stash-error.title", defaultValue: "Cannot Stash Changes", comment: "Alert title when stash operation cannot proceed"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspace-sheets.source-control.stash-error.ok", defaultValue: "OK", comment: "Acknowledgement button for stash changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.source-control.stash-error.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no local uncommitted changes to stash"))
            }
            .alert(String(localized: "workspace-sheets.source-control.discard-error.title", defaultValue: "Cannot Discard Changes", comment: "Alert title when discard all changes operation cannot proceed"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspace-sheets.source-control.discard-error.ok", defaultValue: "OK", comment: "Acknowledgement button for discard changes error alert"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace-sheets.source-control.discard-error.no-uncommitted-changes", defaultValue: "There are no uncommitted changes in the local repository for this project.", comment: "Message shown when there are no local uncommitted changes to discard"))
            }
    }
}
