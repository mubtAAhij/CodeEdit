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
        CommandMenu(String(localized: "menu.source-control", defaultValue: "Source Control", comment: "Source Control menu")) {
            Group {
                Button(String(localized: "source-control.commit", defaultValue: "Commit...", comment: "Commit menu command")) {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button(String(localized: "source-control.push", defaultValue: "Push...", comment: "Push menu command")) {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button(String(localized: "source-control.pull", defaultValue: "Pull...", comment: "Pull menu command")) {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button(String(localized: "source-control.fetch-changes", defaultValue: "Fetch Changes", comment: "Fetch Changes menu command")) {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button(String(localized: "source-control.stage-all-changes", defaultValue: "Stage All Changes", comment: "Stage All Changes menu command")) {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source-control.failed-to-stage-changes", defaultValue: "Failed To Stage Changes", comment: "Error alert title when staging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button(String(localized: "source-control.unstage-all-changes", defaultValue: "Unstage All Changes", comment: "Unstage All Changes menu command")) {
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
                                    title: String(localized: "source-control.failed-to-unstage-changes", defaultValue: "Failed To Unstage Changes", comment: "Error alert title when unstaging changes fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button(String(localized: "source-control.cherry-pick", defaultValue: "Cherry-Pick...", comment: "Cherry-Pick menu command")) {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button(String(localized: "source-control.stash-changes", defaultValue: "Stash Changes...", comment: "Stash Changes menu command")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control.discard-all-changes", defaultValue: "Discard All Changes...", comment: "Discard All Changes menu command")) {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button(String(localized: "source-control.add-existing-remote", defaultValue: "Add Exisiting Remote...", comment: "Add Existing Remote menu command")) {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
