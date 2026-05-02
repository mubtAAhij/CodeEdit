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
        CommandMenu(String(localized: "source.control.menu", defaultValue: "Source Control", comment: "Source Control menu title")) {
            Group {
                Button(String(localized: "source.control.commit", defaultValue: "Commit...", comment: "Source Control commit menu item")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "source.control.push", defaultValue: "Push...", comment: "Source Control push menu item")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "source.control.pull", defaultValue: "Pull...", comment: "Source Control pull menu item")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut(KeyEquivalent(Character(String(localized: "source.control.pull.shortcut", defaultValue: "x", comment: "Source Control pull keyboard shortcut key"))), modifiers: [.command, .option])

                Button(String(localized: "source.control.fetch", defaultValue: "Fetch Changes", comment: "Source Control fetch changes menu item")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "source.control.stage.all", defaultValue: "Stage All Changes", comment: "Source Control stage all changes menu item")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source.control.stage.failed", defaultValue: "Failed To Stage Changes", comment: "Error alert title when staging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "source.control.unstage.all", defaultValue: "Unstage All Changes", comment: "Source Control unstage all changes menu item")) {
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
                                    title: String(localized: "source.control.unstage.failed", defaultValue: "Failed To Unstage Changes", comment: "Error alert title when unstaging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "source.control.cherry.pick", defaultValue: "Cherry-Pick...", comment: "Source Control cherry-pick menu item")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "source.control.stash", defaultValue: "Stash Changes...", comment: "Source Control stash changes menu item")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source.control.discard.all", defaultValue: "Discard All Changes...", comment: "Source Control discard all changes menu item")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source.control.add.remote", defaultValue: "Add Exisiting Remote...", comment: "Source Control add existing remote menu item")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
