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
                    title: Text(String(localized: "workspaceSheets.discardAllChanges", comment: "Alert title")),
                    message: Text(String(localized: "workspaceSheets.cannotBeUndone", comment: "Alert message")),
                    primaryButton: .destructive(Text(String(localized: "workspaceSheets.discard", comment: "Button text"))) {
                        sourceControlManager.discardAllChanges()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(String(localized: "workspaceSheets.cannotStageChanges", comment: "Alert title"), isPresented: $sourceControlManager.noChangesToStageAlertIsPresented) {
                Button(String(localized: "workspaceSheets.ok", comment: "Button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspaceSheets.noUncommittedChanges", comment: "Alert message"))
            }
            .alert(String(localized: "workspaceSheets.cannotUnstageChanges", comment: "Alert title"), isPresented: $sourceControlManager.noChangesToUnstageAlertIsPresented) {
                Button(String(localized: "workspaceSheets.ok", comment: "Button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspaceSheets.noUncommittedChanges", comment: "Alert message"))
            }
            .alert(String(localized: "workspaceSheets.cannotStashChanges", comment: "Alert title"), isPresented: $sourceControlManager.noChangesToStashAlertIsPresented) {
                Button(String(localized: "workspaceSheets.ok", comment: "Button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspaceSheets.noUncommittedChanges", comment: "Alert message"))
            }
            .alert(String(localized: "workspaceSheets.cannotDiscardChanges", comment: "Alert title"), isPresented: $sourceControlManager.noChangesToDiscardAlertIsPresented) {
                Button(String(localized: "workspaceSheets.ok", comment: "Button text"), role: .cancel) {}
            } message: {
                Text(String(localized: "workspaceSheets.noUncommittedChanges", comment: "Alert message"))
            }
    }
}
