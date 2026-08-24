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
        CommandMenu(String(localized: "windowcommands.source-control.title", defaultValue: "Source Control", comment: "Top-level title for source control commands menu")) {
            Group {
                Button(String(localized: "windowcommands.source-control.commit", defaultValue: "Commit...", comment: "Menu item title to open commit action")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "windowcommands.source-control.push", defaultValue: "Push...", comment: "Menu item title to push changes")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "windowcommands.source-control.pull", defaultValue: "Pull...", comment: "Menu item title to pull changes")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "windowcommands.source-control.fetch-changes", defaultValue: "Fetch Changes", comment: "Menu item title to fetch source control changes")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "windowcommands.source-control.stage-all-changes", defaultValue: "Stage All Changes", comment: "Menu item title to stage all repository changes")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "windowcommands.source-control.failed-to-stage-changes", defaultValue: "Failed To Stage Changes", comment: "Error message title when staging all changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "windowcommands.source-control.unstage-all-changes", defaultValue: "Unstage All Changes", comment: "Menu item title to unstage all repository changes")) {
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
                                    title: String(localized: "windowcommands.source-control.failed-to-unstage-changes", defaultValue: "Failed To Unstage Changes", comment: "Error message title when unstaging all changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "windowcommands.source-control.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Menu item title to open cherry-pick action")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "windowcommands.source-control.stash-changes", defaultValue: "Stash Changes...", comment: "Menu item title to stash repository changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "windowcommands.source-control.discard-all-changes", defaultValue: "Discard All Changes...", comment: "Menu item title to discard all repository changes")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "windowcommands.source-control.add-existing-remote", defaultValue: "Add Exisiting Remote...", comment: "Menu item title to add an existing remote repository")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
