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
        CommandMenu("source_control.menu", comment: "Source Control menu title") {
            Group {
                Button("source_control.commit.action_ellipsis", comment: "Commit action with ellipsis") {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button("source_control.push", comment: "Push action") {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button("source_control.pull", comment: "Pull action") {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button("source_control.fetch_changes", comment: "Fetch changes action") {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button("source_control.stage_all_changes", comment: "Stage all changes action") {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source_control.error.failed_to_stage_changes", comment: "Error when staging fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button("source_control.unstage_all_changes", comment: "Unstage all changes action") {
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
                                    title: String(localized: "source_control.error.failed_to_unstage_changes", comment: "Error when unstaging fails"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button("source_control.cherry_pick", comment: "Cherry-pick action") {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button("source_control.stash_changes", comment: "Stash changes action") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button("source_control.discard_all_changes", comment: "Discard all changes action") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button("source_control.add_existing_remote_typo", comment: "Add existing remote action") {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
