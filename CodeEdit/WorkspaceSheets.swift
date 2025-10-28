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
                    title: Text("source_control.discard_changes.title", comment: "Alert title"),
                    message: Text("source_control.discard_changes.message", comment: "Alert message"),
                    primaryButton: .destructive(Text("source_control.discard_changes.action", comment: "Destructive button")) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert("source_control.cannot_stage_changes", comment: "Alert title", isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button("actions.ok", comment: "Button text", role: .cancel) {}
            } message: {
                Text("source_control.no_uncommitted_changes", comment: "Alert message")
            }
            .alert("source_control.cannot_unstage_changes", comment: "Alert title", isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button("actions.ok", comment: "Button text", role: .cancel) {}
            } message: {
                Text("source_control.no_uncommitted_changes", comment: "Alert message")
            }
            .alert("source_control.cannot_stash_changes", comment: "Alert title", isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button("actions.ok", comment: "Button text", role: .cancel) {}
            } message: {
                Text("source_control.no_uncommitted_changes", comment: "Alert message")
            }
            .alert("source_control.cannot_discard_changes", comment: "Alert title", isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button("actions.ok", comment: "Button text", role: .cancel) {}
            } message: {
                Text("source_control.no_uncommitted_changes", comment: "Alert message")
            }
    }
}
