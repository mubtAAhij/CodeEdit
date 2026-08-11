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
        CommandMenu(String(localized: "window-commands.source-control.title", defaultValue: "Source Control", comment: "Top-level source control menu title in window commands")) {
            Group {
                Button(String(localized: "window-commands.source-control.commit", defaultValue: "Commit...", comment: "Source control menu command to open commit workflow")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "window-commands.source-control.push", defaultValue: "Push...", comment: "Source control menu command to push changes")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "window-commands.source-control.pull", defaultValue: "Pull...", comment: "Source control menu command to pull changes")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "window-commands.source-control.fetch-changes", defaultValue: "Fetch Changes", comment: "Source control menu command to fetch remote changes")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "window-commands.source-control.stage-all-changes", defaultValue: "Stage All Changes", comment: "Source control menu command to stage all changes")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "window-commands.source-control.failed-to-stage-changes", defaultValue: "Failed To Stage Changes", comment: "Error message title when staging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "window-commands.source-control.unstage-all-changes", defaultValue: "Unstage All Changes", comment: "Source control menu command to unstage all changes")) {
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
                                    title: String(localized: "window-commands.source-control.failed-to-unstage-changes", defaultValue: "Failed To Unstage Changes", comment: "Error message title when unstaging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Source control menu command to start cherry-pick workflow")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "window-commands.source-control.stash-changes", defaultValue: "Stash Changes...", comment: "Source control menu command to stash current changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.discard-all-changes", defaultValue: "Discard All Changes...", comment: "Source control menu command to discard all changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window-commands.source-control.add-existing-remote", defaultValue: "Add Exisiting Remote...", comment: "Source control menu command to add an existing remote")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
