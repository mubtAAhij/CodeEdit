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
                    title: Text(String(localized: "discard_all_changes_title", comment: "Alert title asking to discard all uncommitted changes")),
                    message: Text(String(localized: "action_cannot_be_undone", comment: "Alert message warning that action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "discard", comment: "Button text to discard changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "cannot_stage_changes", comment: "Alert title when cannot stage changes"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when no uncommitted changes exist"))
            }
            .alert(String(localized: "cannot_unstage_changes", comment: "Alert title for unstage failure"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when no uncommitted changes exist"))
            }
            .alert(String(localized: "cannot_stash_changes", comment: "Alert title for stash failure"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when no uncommitted changes exist"))
            }
            .alert(String(localized: "cannot_discard_changes", comment: "Alert title for discard failure"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "ok", comment: "OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "no_uncommitted_changes", comment: "Message when no uncommitted changes exist"))
            }
    }
}
