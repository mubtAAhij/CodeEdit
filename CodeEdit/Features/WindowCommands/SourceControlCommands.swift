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
        CommandMenu("String(localized: "source_control", comment: "Menu title for source control commands")") {
            Group {
                Button("String(localized: "commit", comment: "Menu item to commit changes")") {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button("String(localized: "push", comment: "Menu item to push changes to remote")") {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button("String(localized: "pull", comment: "Menu item to pull changes from remote")") {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button("String(localized: "fetch_changes", comment: "Menu item to fetch changes from remote")") {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button("String(localized: "stage_all_changes", comment: "Menu item to stage all changes")") {
                    guard let sourceControlManager else { return }
                    if sourceControlManager.changedFiles.isEmpty {
                        sourceControlManager.noChangesToStageAlertIsPresented = true
                    } else {
                        Task {
                            do {
                                try await sourceControlManager.add(sourceControlManager.changedFiles.map { $0.fileURL })
                            } catch {
                                await sourceControlManager.showAlertForError(
                                    title: "String(localized: "failed_to_stage_changes", comment: "Error message when staging changes fails")",
                                    error: error
                                )
                            }
                        }
                    }
                }

                Button("String(localized: "unstage_all_changes", comment: "Menu item to unstage all changes")") {
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
                                    title: "String(localized: "failed_to_unstage_changes", comment: "Error message when unstaging changes fails")",
                                    error: error
                                )
                            }
                        }
                    }
                }

                Divider()

                Button("String(localized: "cherry_pick", comment: "Menu item to cherry-pick commits")") {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button("String(localized: "stash_changes", comment: "Menu item to stash changes")") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button("String(localized: "discard_all_changes", comment: "Menu item to discard all changes")") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button("String(localized: "add_existing_remote", comment: "Menu item to add existing remote repository")") {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
