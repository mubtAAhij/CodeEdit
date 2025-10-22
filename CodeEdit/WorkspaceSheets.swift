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
                    title: Text(String(localized: "Do you want to discard all uncommitted, local changes?")),
                    message: Text(String(localized: "This action cannot be undone.")),
                    primaryButton: .destructive(Text(String(localized: "Discard"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "Cannot Stage Changes"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "There are no uncommitted changes in the local repository for this project."))
            }
            .alert(String(localized: "Cannot Unstage Changes"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "There are no uncommitted changes in the local repository for this project."))
            }
            .alert(String(localized: "Cannot Stash Changes"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "There are no uncommitted changes in the local repository for this project."))
            }
            .alert(String(localized: "Cannot Discard Changes"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "There are no uncommitted changes in the local repository for this project."))
            }
    }
}
