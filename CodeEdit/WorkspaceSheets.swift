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
                    title: Text(String(localized: "discard_changes_confirmation", comment: "Confirmation dialog asking user to discard uncommitted changes")),
                    message: Text(String(localized: "action_cannot_be_undone", comment: "Warning message that action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "discard_button", comment: "Button text to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "cannot_stage_changes", comment: "Error message when changes cannot be staged"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "ok_button", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository"))
            }
            .alert(String(localized: "cannot_unstage_changes", comment: "Error message when changes cannot be unstaged"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "ok_button", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository"))
            }
            .alert(String(localized: "cannot_stash_changes", comment: "Error message when changes cannot be stashed"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "ok_button", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository"))
            }
            .alert(String(localized: "cannot_discard_changes", comment: "Error message when changes cannot be discarded"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "ok_button", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.")
            }
    }
}
