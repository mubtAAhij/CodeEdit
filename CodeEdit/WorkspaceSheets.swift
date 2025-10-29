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
                    title: Text("Do you want to discard all uncommitted, local changes?", comment: "Alert title asking user to confirm discarding all uncommitted changes"),
                    message: Text("This action cannot be undone.", comment: "Alert message warning that discarding changes cannot be undone"),
                    primaryButton: .destructive(Text("Discard", comment: "Button to confirm discarding changes")) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "Cannot Stage Changes", comment: "Alert title when there are no changes to stage"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to stage")
            }
            .alert(String(localized: "Cannot Unstage Changes", comment: "Alert title when there are no changes to unstage"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to unstage")
            }
            .alert(String(localized: "Cannot Stash Changes", comment: "Alert title when there are no changes to stash"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to stash")
            }
            .alert(String(localized: "Cannot Discard Changes", comment: "Alert title when there are no changes to discard"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "OK", comment: "OK button"), role: .cancel) {}
            } message: {
                Text("There are no uncommitted changes in the local repository for this project.", comment: "Alert message when there are no changes to discard")
            }
    }
}
