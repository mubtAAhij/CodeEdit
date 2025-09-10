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
                    title: Text("String(localized: "discard_uncommitted_changes_question", comment: "Confirmation dialog asking user if they want to discard uncommitted changes")"),
                    message: Text("String(localized: "action_cannot_be_undone", comment: "Warning message that an action is irreversible")"),
                    primaryButton: .destructive(Text("String(localized: "discard", comment: "Button label for discarding changes")")) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert("String(localized: "cannot_stage_changes", comment: "Alert title when unable to stage changes")", isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button("String(localized: "ok", comment: "OK button label")", role: .cancel) {}
            } message: {
                Text("String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository")")
            }
            .alert("String(localized: "cannot_unstage_changes", comment: "Alert title when unable to unstage changes")", isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button("String(localized: "ok", comment: "OK button label")", role: .cancel) {}
            } message: {
                Text("String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository")")
            }
            .alert("String(localized: "cannot_stash_changes", comment: "Alert title when unable to stash changes")", isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button("String(localized: "ok", comment: "OK button label")", role: .cancel) {}
            } message: {
                Text("String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository")")
            }
            .alert("String(localized: "cannot_discard_changes", comment: "Alert title when unable to discard changes")", isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button("String(localized: "ok", comment: "OK button label")", role: .cancel) {}
            } message: {
                Text("String(localized: "no_uncommitted_changes", comment: "Message when there are no uncommitted changes in repository")")
            }
    }
}
