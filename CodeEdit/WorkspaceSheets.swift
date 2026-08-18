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
                    title: Text(String(
                        localized: "workspace-sheets.discard-local-changes.confirmation-title",
                        defaultValue: "Do you want to discard all uncommitted, local changes?",
                        comment: "Confirmation title before discarding all local uncommitted changes"
                    )),
                    message: Text(String(
                        localized: "workspace-sheets.common.action-cannot-be-undone",
                        defaultValue: "This action cannot be undone.",
                        comment: "Warning message that action is irreversible"
                    )),
                    primaryButton: .destructive(Text(String(
                        localized: "workspace-sheets.discard-local-changes.discard-button",
                        defaultValue: "Discard",
                        comment: "Destructive button title to discard changes"
                    ))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(
                localized: "workspace-sheets.stage-changes.error-title",
                defaultValue: "Cannot Stage Changes",
                comment: "Error alert title when stage changes action fails"
            ), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(
                    localized: "workspace-sheets.common.ok-button",
                    defaultValue: "OK",
                    comment: "Default confirmation button title for alerts"
                ), role: .cancel) {}
            } message: {
                Text(String(
                    localized: "workspace-sheets.no-uncommitted-changes.message",
                    defaultValue: "There are no uncommitted changes in the local repository for this project.",
                    comment: "Message shown when no local uncommitted changes are available"
                ))
            }
            .alert(String(
                localized: "workspace-sheets.unstage-changes.error-title",
                defaultValue: "Cannot Unstage Changes",
                comment: "Error alert title when unstage changes action fails"
            ), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(
                    localized: "workspace-sheets.common.ok-button",
                    defaultValue: "OK",
                    comment: "Default confirmation button title for alerts"
                ), role: .cancel) {}
            } message: {
                Text(String(
                    localized: "workspace-sheets.no-uncommitted-changes.message",
                    defaultValue: "There are no uncommitted changes in the local repository for this project.",
                    comment: "Message shown when no local uncommitted changes are available"
                ))
            }
            .alert(String(
                localized: "workspace-sheets.stash-changes.error-title",
                defaultValue: "Cannot Stash Changes",
                comment: "Error alert title when stash changes action fails"
            ), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(
                    localized: "workspace-sheets.common.ok-button",
                    defaultValue: "OK",
                    comment: "Default confirmation button title for alerts"
                ), role: .cancel) {}
            } message: {
                Text(String(
                    localized: "workspace-sheets.no-uncommitted-changes.message",
                    defaultValue: "There are no uncommitted changes in the local repository for this project.",
                    comment: "Message shown when no local uncommitted changes are available"
                ))
            }
            .alert(String(
                localized: "workspace-sheets.discard-changes.error-title",
                defaultValue: "Cannot Discard Changes",
                comment: "Error alert title when discard changes action fails"
            ), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(
                    localized: "workspace-sheets.common.ok-button",
                    defaultValue: "OK",
                    comment: "Default confirmation button title for alerts"
                ), role: .cancel) {}
            } message: {
                Text(String(
                    localized: "workspace-sheets.no-uncommitted-changes.message",
                    defaultValue: "There are no uncommitted changes in the local repository for this project.",
                    comment: "Message shown when no local uncommitted changes are available"
                ))
            }
    }
}
