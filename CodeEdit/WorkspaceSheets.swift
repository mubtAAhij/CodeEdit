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
                    title: Text("Do you want to discard all uncommitted, local changes?"),
                    message: Text(String(localized: "workspace.discard_changes.warning", comment: "Warning that discard action is irreversible")),
                    primaryButton: .destructive(Text(String(localized: "workspace.discard_changes.button", comment: "Button to confirm discarding changes"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspace.error.cannot_stage_changes", comment: "Error title when unable to stage git changes"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "general.ok", comment: "Standard OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.error.no_uncommitted_changes", comment: "Error message when no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.error.cannot_unstage_changes", comment: "Error title when unable to unstage git changes"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "general.ok", comment: "Standard OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.error.no_uncommitted_changes", comment: "Error message when no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.error.cannot_stash_changes", comment: "Error title when unable to stash git changes"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "general.ok", comment: "Standard OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.error.no_uncommitted_changes", comment: "Error message when no uncommitted changes exist"))
            }
            .alert(String(localized: "workspace.error.cannot_discard_changes", comment: "Error title when unable to discard git changes"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "general.ok", comment: "Standard OK button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspace.error.no_uncommitted_changes", comment: "Error message when no uncommitted changes exist"))
            }
    }
}
