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
        CommandMenu(String(localized: "source-control-commands.menu-title", defaultValue: "Source Control", comment: "Source control menu title")) {
            Group {
                Button(String(localized: "source-control-commands.commit", defaultValue: "Commit...", comment: "Commit command")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "source-control-commands.push", defaultValue: "Push...", comment: "Push command")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "source-control-commands.pull", defaultValue: "Pull...", comment: "Pull command")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "source-control-commands.fetch-changes", defaultValue: "Fetch Changes", comment: "Fetch changes command")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "source-control-commands.stage-all", defaultValue: "Stage All Changes", comment: "Stage all changes command")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source-control-commands.failed-to-stage", defaultValue: "Failed To Stage Changes", comment: "Failed to stage changes error"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "source-control-commands.unstage-all", defaultValue: "Unstage All Changes", comment: "Unstage all changes command")) {
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
                                    title: String(localized: "source-control-commands.failed-to-unstage", defaultValue: "Failed To Unstage Changes", comment: "Failed to unstage changes error"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "source-control-commands.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Cherry-pick command")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "source-control-commands.stash-changes", defaultValue: "Stash Changes...", comment: "Stash changes command")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control-commands.discard-all", defaultValue: "Discard All Changes...", comment: "Discard all changes command")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control-commands.add-remote", defaultValue: "Add Exisiting Remote...", comment: "Add existing remote command")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
