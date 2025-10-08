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
                    title: Text(String(localized: "workspace.discard_changes.confirmation_title", comment: "Confirmation dialog title for discarding uncommitted changes")),
                    message: Text(String(localized: "workspace.discard_changes.warning_message", comment: "Warning message that discard action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard_changes.button_title", comment: "Button title for discarding changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.stage_changes.error_title", comment: "Error dialog title when unable to stage changes"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "general.ok_button", comment: "OK button title"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes.message", comment: "Message when there are no uncommitted changes in the repository"))
            }
            .alert(String(localized: "workspace.unstage_changes.error_title", comment: "Error dialog title when unable to unstage changes"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.")
            }
            .alert(String(localized: "workspace.stash_changes.error_title", comment: "Error dialog title when unable to stash changes"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "general.ok_button", comment: "OK button title"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.no_uncommitted_changes.message", comment: "Message when there are no uncommitted changes in the repository"))
            }
            .alert(String(localized: "workspace.discard_changes.error_title", comment: "Error dialog title when unable to discard changes"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.")
            }
    }
}
