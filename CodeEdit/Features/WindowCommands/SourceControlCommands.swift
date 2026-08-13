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
        CommandMenu(String(localized: "window-commands.source-control.menu", defaultValue: "Source Control", comment: "Source control command menu title")) {
            Group {
                Button(String(localized: "window-commands.source-control.commit.button", defaultValue: "Commit...", comment: "Opens commit workflow")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "window-commands.source-control.push.button", defaultValue: "Push...", comment: "Push command button")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "window-commands.source-control.pull.button", defaultValue: "Pull...", comment: "Pull command button")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "window-commands.source-control.fetch-changes.button", defaultValue: "Fetch Changes", comment: "Fetch changes command button")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "window-commands.source-control.stage-all.button", defaultValue: "Stage All Changes", comment: "Stages all changed files")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "window-commands.source-control.stage-all.error-title", defaultValue: "Failed To Stage Changes", comment: "Error alert title when staging fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "window-commands.source-control.unstage-all.button", defaultValue: "Unstage All Changes", comment: "Unstages all changed files")) {
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
                                    title: String(localized: "window-commands.source-control.unstage-all.error-title", defaultValue: "Failed To Unstage Changes", comment: "Error alert title when unstaging fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.cherry-pick.button", defaultValue: "Cherry-Pick...", comment: "Opens cherry-pick workflow")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "window-commands.source-control.stash-changes.button", defaultValue: "Stash Changes...", comment: "Stash changes command button")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.discard-all.button", defaultValue: "Discard All Changes...", comment: "Discard all changes command button")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.add-existing-remote.button", defaultValue: "Add Exisiting Remote...", comment: "Opens add existing remote workflow")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
