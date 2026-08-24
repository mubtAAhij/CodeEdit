//
//  SourceControlCommands.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/29/24.
//

import SwiftUI

struct SourceControlCommands: Commands {
    @State private var windowController: CodeEditWindowController?

    @State private var confirmDiscardChanges: Bool = false

    var sourceControlManager: SourceControlManager? {
        windowController?.workspace?.sourceControlManager
    }

    var body: some Commands {
        CommandMenu(String(
    localized: "window-commands.source-control.menu-title",
    defaultValue: "Source Control",
    comment: "Title for the Source Control command menu"
)) {
            Group {
            Button(String(
    localized: "window-commands.source-control.commit-ellipsis",
    defaultValue: "Commit...",
    comment: "Command to open commit workflow"
)) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

            Button(String(
    localized: "window-commands.source-control.push-ellipsis",
    defaultValue: "Push...",
    comment: "Command to push changes"
)) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

            Button(String(
    localized: "window-commands.source-control.pull-ellipsis",
    defaultValue: "Pull...",
    comment: "Command to pull changes"
)) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

            Button(String(
    localized: "window-commands.source-control.fetch-changes",
    defaultValue: "Fetch Changes",
    comment: "Command to fetch repository changes"
)) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

            Button(String(
    localized: "window-commands.source-control.stage-all-changes",
    defaultValue: "Stage All Changes",
    comment: "Command to stage all modified files"
)) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                        title: String(
    localized: "window-commands.source-control.failed-to-stage-changes",
    defaultValue: "Failed To Stage Changes",
    comment: "Alert title when staging all changes fails"
),
                                    error: error
                                )
                            }
                        }
                    }
                }

            Button(String(
    localized: "window-commands.source-control.unstage-all-changes",
    defaultValue: "Unstage All Changes",
    comment: "Command to unstage all modified files"
)) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToUnstageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.reset(
                                    sourceControlManager.changedFiles.map { $0.fileURL }
                                )
                            } catch {
                                await sourceControlManager.showAlertForError(
                        title: String(
    localized: "window-commands.source-control.failed-to-unstage-changes",
    defaultValue: "Failed To Unstage Changes",
    comment: "Alert title when unstaging all changes fails"
),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

            Button(String(
    localized: "window-commands.source-control.cherry-pick-ellipsis",
    defaultValue: "Cherry-Pick...",
    comment: "Command to cherry-pick commits"
)) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

            Button(String(
    localized: "window-commands.source-control.stash-changes-ellipsis",
    defaultValue: "Stash Changes...",
    comment: "Command to stash local changes"
)) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

            Button(String(
    localized: "window-commands.source-control.discard-all-changes-ellipsis",
    defaultValue: "Discard All Changes...",
    comment: "Command to discard all local changes"
)) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

            Button(String(
    localized: "window-commands.source-control.add-existing-remote-ellipsis",
    defaultValue: "Add Exisiting Remote...",
    comment: "Command to add an existing remote"
)) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
