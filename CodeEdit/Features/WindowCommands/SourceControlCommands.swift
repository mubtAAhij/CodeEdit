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
        CommandMenu(String(localized: "window.source-control.title", defaultValue: "Source Control", comment: "Title for source control command menu")) {
            Group {
                Button(String(localized: "window.source-control.commit", defaultValue: "Commit...", comment: "Menu command to open commit flow")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "window.source-control.push", defaultValue: "Push...", comment: "Menu command to push changes to remote")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "window.source-control.pull", defaultValue: "Pull...", comment: "Menu command to pull changes from remote")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "window.source-control.fetch-changes", defaultValue: "Fetch Changes", comment: "Menu command to fetch source control changes")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "window.source-control.stage-all-changes", defaultValue: "Stage All Changes", comment: "Menu command to stage all changes")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "window.source-control.stage-all-changes.error", defaultValue: "Failed To Stage Changes", comment: "Error title shown when staging all changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "window.source-control.unstage-all-changes", defaultValue: "Unstage All Changes", comment: "Menu command to unstage all changes")) {
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
                                    title: String(localized: "window.source-control.unstage-all-changes.error", defaultValue: "Failed To Unstage Changes", comment: "Error title shown when unstaging all changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "window.source-control.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Menu command to start cherry-pick flow")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "window.source_control.stash_changes", defaultValue: "Stash Changes...", comment: "Source control menu command to stash current changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window.source_control.discard_all_changes", defaultValue: "Discard All Changes...", comment: "Source control menu command to discard all current changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "window.source_control.add_existing_remote", defaultValue: "Add Exisiting Remote...", comment: "Source control menu command to add an existing remote repository")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
