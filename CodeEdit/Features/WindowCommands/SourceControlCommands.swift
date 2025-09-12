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
        CommandMenu("String(localized: "source_control", comment: "Source Control menu title")") {
            Group {
                Button("String(localized: "commit", comment: "Menu item to commit changes")") {
                    // TODO: Open Source Control Navigator to Changes tab
                }
                .disabled(true)

                Button("String(localized: "push", comment: "Menu item to push changes")") {
                    sourceControlManager?.pushSheetIsPresented = true
                }

                Button("String(localized: "pull", comment: "Menu item to pull changes")") {
                    sourceControlManager?.pullSheetIsPresented = true
                }
                .keyboardShortcut("x", modifiers: [.command, .option])

                Button("String(localized: "fetch_changes", comment: "Menu item to fetch changes")") {
                    sourceControlManager?.fetchSheetIsPresented = true
                }

                Divider()

                Button("String(localized: "stage_all_changes", comment: "Button title for staging all changes in source control")") {
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

                Button("String(localized: "unstage_all_changes", comment: "Button title for unstaging all changes in source control")") {
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

                Button("String(localized: "cherry_pick", comment: "Button title for cherry-pick action")") {
                    // TODO: Implementation Needed
                }
                .disabled(true)

                Button("String(localized: "stash_changes", comment: "Button title for stashing changes")") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToStashAlertIsPresented = true
                    } else {
                        sourceControlManager?.stashSheetIsPresented = true
                    }
                }

                Divider()

                Button("String(localized: "discard_all_changes", comment: "Button title for discarding all changes")") {
                    if sourceControlManager?.changedFiles.isEmpty ?? false {
                        sourceControlManager?.noChangesToDiscardAlertIsPresented = true
                    } else {
                        sourceControlManager?.discardAllAlertIsPresented = true
                    }
                }

                Divider()

                Button("String(localized: "add_existing_remote", comment: "Button title for adding existing remote")") {
                    sourceControlManager?.addExistingRemoteSheetIsPresented = true
                }
            }
            .disabled(windowController?.workspace == nil)
            .observeWindowController($windowController)
        }
    }
}
