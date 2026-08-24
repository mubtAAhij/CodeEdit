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
            comment: "Source control command menu title"
        )) {
            Group {
                Button(String(
                    localized: "window-commands.source-control.commit",
                    defaultValue: "Commit...",
                    comment: "Source control command to open commit workflow"
                )) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(
                    localized: "window-commands.source-control.push",
                    defaultValue: "Push...",
                    comment: "Source control command to push commits"
                )) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(
                    localized: "window-commands.source-control.pull",
                    defaultValue: "Pull...",
                    comment: "Source control command to pull changes"
                )) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(
                    localized: "window-commands.source-control.fetch-changes",
                    defaultValue: "Fetch Changes",
                    comment: "Source control command to fetch changes"
                )) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.stage-all-changes",
                    defaultValue: "Stage All Changes",
                    comment: "Source control command to stage all changes"
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
                                        localized: "window-commands.source-control.stage-all-changes-error-title",
                                        defaultValue: "Failed To Stage Changes",
                                        comment: "Error alert title when staging all changes fails"
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
                    comment: "Source control command to unstage all changes"
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
                                        localized: "window-commands.source-control.unstage-all-changes-error-title",
                                        defaultValue: "Failed To Unstage Changes",
                                        comment: "Error alert title when unstaging all changes fails"
                                    ),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.cherry-pick",
                    defaultValue: "Cherry-Pick...",
                    comment: "Source control command to cherry-pick commits"
                )) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(
                    localized: "window-commands.source-control.stash-changes",
                    defaultValue: "Stash Changes...",
                    comment: "Source control command to stash changes"
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.discard-all-changes",
                    defaultValue: "Discard All Changes...",
                    comment: "Source control command to discard all changes"
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.add-existing-remote",
                    defaultValue: "Add Exisiting Remote...",
                    comment: "Source control command to add an existing remote"
                )) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
