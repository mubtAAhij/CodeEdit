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
        CommandMenu(String(localized: "source-control.menu.title", defaultValue: "Source Control", comment: "Source Control menu title")) {
            Group {
                Button(String(localized: "source-control.commit", defaultValue: "Commit...", comment: "Commit button label")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "source-control.push", defaultValue: "Push...", comment: "Push button label")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "source-control.pull", defaultValue: "Pull...", comment: "Pull button label")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "source-control.fetch-changes", defaultValue: "Fetch Changes", comment: "Fetch Changes button label")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "source-control.stage-all", defaultValue: "Stage All Changes", comment: "Stage All Changes button label")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source-control.error.stage-failed", defaultValue: "Failed To Stage Changes", comment: "Error title when staging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "source-control.unstage-all", defaultValue: "Unstage All Changes", comment: "Unstage All Changes button label")) {
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
                                    title: String(localized: "source-control.error.unstage-failed", defaultValue: "Failed To Unstage Changes", comment: "Error title when unstaging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "source-control.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Cherry-Pick button label")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "source-control.stash-changes", defaultValue: "Stash Changes...", comment: "Stash Changes button label")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control.discard-all", defaultValue: "Discard All Changes...", comment: "Discard All Changes button label")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control.add-remote-add-exisiting-remote", defaultValue: "Add Exisiting Remote...", comment: "Add Existing Remote button label")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
