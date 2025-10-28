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
        CommandMenu("source_control.menu", comment: "Source Control menu") {
            Group {
                Button("source_control.actions.commit", comment: "Commit action") {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button("source_control.actions.push", comment: "Push action") {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button("source_control.actions.pull", comment: "Pull action") {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button("source_control.actions.fetch_changes", comment: "Fetch Changes action") {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button("source_control.actions.stage_all_changes", comment: "Stage All Changes action") {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: String(localized: "source_control.errors.failed_to_stage_changes", comment: "Failed To Stage Changes error"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button("source_control.actions.unstage_all_changes", comment: "Unstage All Changes action") {
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
                                    title: String(localized: "source_control.errors.failed_to_unstage_changes", comment: "Failed To Unstage Changes error"),
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button("source_control.actions.cherry_pick", comment: "Cherry-Pick action") {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button("source_control.actions.stash_changes", comment: "Stash Changes action") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button("source_control.actions.discard_all_changes", comment: "Discard All Changes action") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button("source_control.actions.add_existing_remote", comment: "Add Existing Remote action") {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
