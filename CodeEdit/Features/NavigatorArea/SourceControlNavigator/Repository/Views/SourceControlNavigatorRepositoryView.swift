//
//  SourceControlNavigatorRepositoryView.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/05/20.
//

import SwiftUI
import CodeEditSymbols

struct SourceControlNavigatorRepositoryView: View {
    @Environment(\.controlActiveState)
    var controlActiveState

    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State var selection = Set<String>()
    @State var showNewBranch: Bool = false
    @State var showRenameBranch: Bool = false
    @State var fromBranch: GitBranch?
    @State var expandedIds = [String: Bool]()
    @State var applyStashedChangesIsPresented: Bool = false
    @State var isPresentingConfirmDeleteBranch: Bool = false
    @State var branchToDelete: GitBranch?
    @State var isPresentingConfirmDeleteStashEntry: Bool = false
    @State var stashEntryToApply: GitStashEntry?
    @State var stashEntryToDelete: GitStashEntry?
    @State var isPresentingConfirmDeleteRemote: Bool = false
    @State var remoteToDelete: GitRemote?
    @State var keepStashAfterApplying: Bool = true

    func findItem(by id: String, in items: [RepoOutlineGroupItem]) -> RepoOutlineGroupItem? {
        for item in items {
            if item.id == id {
                return item
            } else if let children = item.children, let found = findItem(by: id, in: children) {
                return found
            }
        }
        return nil
    }

    var body: some View {
        List(selection: $selection) {
            ForEach(outlineGroupData, id: \.id) { item in
                CEOutlineGroup(
                    item,
                    id: \.id,
                    defaultExpanded: true,
                    expandedIds: $expandedIds,
                    children: \.children,
                    content: { item in
                        SourceControlNavigatorRepositoryItem(item: item)
                    }
                )
                .listRowSeparator(.hidden)
            }
        }
        .environment(\.defaultMinListRowHeight, 22)
        .contextMenu(
            forSelectionType: RepoOutlineGroupItem.ID.self,
            menu: { items in
                if !items.isEmpty,
                   items.count == 1,
                   let item = findItem(by: items.first ?? "", in: outlineGroupData),
                   let branch = item.branch ?? sourceControlManager.currentBranch {
                    contextMenu(for: item, branch: branch)
                }
            }
        )
        .sheet(isPresented: $showNewBranch) {
            SourceControlNewBranchView(
                fromBranch: $fromBranch
            )
        }
        .sheet(isPresented: $showRenameBranch) {
            SourceControlRenameBranchView(
                fromBranch: $fromBranch
            )
        }
        .alert(
            sourceControlManager.changedFiles.isEmpty
            ? String(
                localized: "source-control.navigator.repository.alert.apply-stash.title",
                defaultValue: "Do you want to apply stashed changes?",
                comment: "Confirmation alert title for applying stashed changes."
            )
            : String(
                localized: "source-control.navigator.repository.alert.apply-stash.uncommitted-changes",
                defaultValue: "The local repository has uncommitted changes.",
                comment: "Alert message indicating there are uncommitted changes before applying stash."
            ),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(
                    localized: "source-control.navigator.repository.alert.apply-stash.action.apply",
                    defaultValue: "Apply",
                    comment: "Primary action button to apply stashed changes."
                )) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(
                    localized: "source-control.navigator.repository.alert.apply-stash.action.apply-and-delete",
                    defaultValue: "Apply and Delete",
                    comment: "Action button to apply and then delete stashed changes."
                )) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(
                    localized: "source-control.navigator.repository.alert.apply-stash.action.cancel",
                    defaultValue: "Cancel",
                    comment: "Cancel button in apply stash confirmation alert."
                ), role: .cancel) {}
            } else {
                Button(String(
                    localized: "source-control.navigator.repository.alert.apply-stash.action.okay",
                    defaultValue: "Okay",
                    comment: "Acknowledgement button in apply stash alert."
                ), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(
                localized: "source-control.navigator.repository.alert.apply-stash.restore-message",
                defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.",
                comment: "Informational message describing effect of applying stashed changes."
            ))
            : Text(String(
                localized: "source-control.navigator.repository.alert.apply-stash.commit-or-discard",
                defaultValue: "Try committing or discarding the changes.",
                comment: "Follow-up guidance shown when stash apply conflicts with local changes."
            ))
        }
        .confirmationDialog(
            String(format: String(
                localized: "source-control.navigator.repository.alert.delete-branch.title",
                defaultValue: "Do you want to delete the branch “%@”?",
                comment: "Confirmation alert title for deleting a branch by name."
            ), "\(branchToDelete?.name ?? "")"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(
                localized: "source-control.navigator.repository.alert.delete-branch.action.delete",
                defaultValue: "Delete",
                comment: "Delete action button in branch deletion alert."
            )) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(
                                    localized: "source-control.navigator.repository.alert.delete-branch.failed",
                                    defaultValue: "Failed to delete",
                                    comment: "Error title shown when branch deletion fails."
                                ),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(
                localized: "source-control.navigator.repository.alert.delete-branch.warning",
                defaultValue: "The branch will be removed from the repository. You can’t undo this action.",
                comment: "Warning message for branch deletion confirmation."
            ))
        }
        .confirmationDialog(
            String(format: String(
                localized: "source-control.navigator.repository.alert.delete-stash.title",
                defaultValue: "Do you want to delete the stash “%@”?",
                comment: "Confirmation alert title for deleting a stash entry by message."
            ), "\(stashEntryToDelete?.message ?? "")"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(
                localized: "source-control.navigator.repository.alert.delete-stash.action.delete",
                defaultValue: "Delete",
                comment: "Delete action button in stash deletion alert."
            )) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(
                                    localized: "source-control.navigator.repository.alert.delete-stash.failed",
                                    defaultValue: "Failed to delete",
                                    comment: "Error title shown when stash deletion fails."
                                ),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(
                localized: "source-control.navigator.repository.alert.delete-stash.warning",
                defaultValue: "The stash will be removed from the repository. You can’t undo this action.",
                comment: "Warning message for stash deletion confirmation."
            ))
        }
        .confirmationDialog(
            String(format: String(
                localized: "source-control.navigator.repository.alert.delete-remote.title",
                defaultValue: "Do you want to delete the remote “%@”?",
                comment: "Confirmation alert title for deleting a remote by name."
            ), "\(remoteToDelete?.name ?? "")"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(
                localized: "source-control.navigator.repository.alert.delete-remote.action.delete",
                defaultValue: "Delete",
                comment: "Delete action button in remote deletion alert."
            )) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(
                                    localized: "source-control.navigator.repository.alert.delete-remote.failed",
                                    defaultValue: "Failed to delete",
                                    comment: "Error title shown when remote deletion fails."
                                ),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(
                localized: "source-control.navigator.repository.alert.delete-remote.warning",
                defaultValue: "The remote will be removed from the repository. You can’t undo this action.",
                comment: "Warning message for remote deletion confirmation."
            ))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
