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
            localized: "source-control-commands.menu",
            defaultValue: "Source Control",
            comment: "Menu title for source control commands"
        )) {
            Group {
                Button(String(
                    localized: "source-control-commands.commit",
                    defaultValue: "Commit...",
                    comment: "Menu item to commit changes"
                )) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(
                    localized: "source-control-commands.push",
                    defaultValue: "Push...",
                    comment: "Menu item to push changes to remote"
                )) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(
                    localized: "source-control-commands.pull",
                    defaultValue: "Pull...",
                    comment: "Menu item to pull changes from remote"
                )) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(
                    localized: "source-control-commands.fetch-changes",
                    defaultValue: "Fetch Changes",
                    comment: "Menu item to fetch changes from remote"
                )) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(
                    localized: "source-control-commands.stage-all-changes",
                    defaultValue: "Stage All Changes",
                    comment: "Menu item to stage all changes"
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
                                        localized: "source-control-commands.error-failed-to-stage",
                                        defaultValue: "Failed To Stage Changes",
                                        comment: "Error title when staging changes fails"
                                    ),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(
                    localized: "source-control-commands.unstage-all-changes",
                    defaultValue: "Unstage All Changes",
                    comment: "Menu item to unstage all changes"
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
                                        localized: "source-control-commands.error-failed-to-unstage",
                                        defaultValue: "Failed To Unstage Changes",
                                        comment: "Error title when unstaging changes fails"
                                    ),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(
                    localized: "source-control-commands.cherry-pick",
                    defaultValue: "Cherry-Pick...",
                    comment: "Menu item to cherry-pick commits"
                )) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(
                    localized: "source-control-commands.stash-changes",
                    defaultValue: "Stash Changes...",
                    comment: "Menu item to stash changes"
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "source-control-commands.discard-all-changes",
                    defaultValue: "Discard All Changes...",
                    comment: "Menu item to discard all changes"
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "source-control-commands.add-existing-remote",
                    defaultValue: "Add Exisiting Remote...",
                    comment: "Menu item to add existing remote"
                )) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
