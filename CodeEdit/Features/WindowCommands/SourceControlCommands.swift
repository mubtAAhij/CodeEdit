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
            comment: "Top-level source control menu title."
        )) {
            Group {
                Button(String(
                    localized: "window-commands.source-control.commit.menu-item",
                    defaultValue: "Commit...",
                    comment: "Menu item title to open commit flow."
                )) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(
                    localized: "window-commands.source-control.push.menu-item",
                    defaultValue: "Push...",
                    comment: "Menu item title to push changes."
                )) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(
                    localized: "window-commands.source-control.pull.menu-item",
                    defaultValue: "Pull...",
                    comment: "Menu item title to pull changes."
                )) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(
                    localized: "window-commands.source-control.fetch-changes.menu-item",
                    defaultValue: "Fetch Changes",
                    comment: "Menu item title to fetch source control changes."
                )) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.stage-all-changes.menu-item",
                    defaultValue: "Stage All Changes",
                    comment: "Menu item title to stage all changes."
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
                                        localized: "window-commands.source-control.stage-all-changes.error",
                                        defaultValue: "Failed To Stage Changes",
                                        comment: "Error message shown when staging all changes fails."
                                    ),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(
                    localized: "window-commands.source-control.unstage-all-changes.menu-item",
                    defaultValue: "Unstage All Changes",
                    comment: "Menu item title to unstage all changes."
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
                                        localized: "window-commands.source-control.unstage-all-changes.error",
                                        defaultValue: "Failed To Unstage Changes",
                                        comment: "Error message shown when unstaging all changes fails."
                                    ),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.cherry-pick.menu-item",
                    defaultValue: "Cherry-Pick...",
                    comment: "Menu item title to cherry-pick commit changes."
                )) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(
                    localized: "window-commands.source-control.stash-changes.menu-item",
                    defaultValue: "Stash Changes...",
                    comment: "Menu item title to stash working changes."
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.discard-all-changes.menu-item",
                    defaultValue: "Discard All Changes...",
                    comment: "Menu item title to discard all current changes."
                )) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(
                    localized: "window-commands.source-control.add-existing-remote.menu-item",
                    defaultValue: "Add Exisiting Remote...",
                    comment: "Menu item title to add an existing remote repository."
                )) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
