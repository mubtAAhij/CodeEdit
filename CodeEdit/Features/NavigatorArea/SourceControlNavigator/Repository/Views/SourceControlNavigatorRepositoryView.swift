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
            ? String(localized: "source_control.apply_stash.title", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title for applying stashed changes")
            : String(localized: "source_control.apply_stash.uncommitted_title", defaultValue: "The local repository has uncommitted changes.", comment: "Alert title when repository has uncommitted changes"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source_control.apply_stash.apply", defaultValue: "Apply", comment: "Button to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source_control.apply_stash.apply_and_delete", defaultValue: "Apply and Delete", comment: "Button to apply and delete stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source_control.apply_stash.cancel", defaultValue: "Cancel", comment: "Cancel button"), role: .cancel) {}
            } else {
                Button(String(localized: "source_control.apply_stash.okay", defaultValue: "Okay", comment: "Okay button"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source_control.apply_stash.message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Message explaining stash application"))
            : Text(String(localized: "source_control.apply_stash.uncommitted_message", defaultValue: "Try committing or discarding the changes.", comment: "Message suggesting to commit or discard changes"))
        }
        .confirmationDialog(
            String(format: String(localized: "source_control.delete_branch.title", defaultValue: "Do you want to delete the branch \"%@\"?", comment: "Confirmation title for deleting branch (branch name)"), branchToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source_control.delete_branch.delete", defaultValue: "Delete", comment: "Delete button for branch")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_branch.failed", defaultValue: "Failed to delete", comment: "Error title when branch deletion fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.delete_branch.message", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Warning message for branch deletion"))
        }
        .confirmationDialog(
            String(format: String(localized: "source_control.delete_stash.title", defaultValue: "Do you want to delete the stash \"%@\"?", comment: "Confirmation title for deleting stash (stash message)"), stashEntryToDelete?.message ?? ""),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source_control.delete_stash.delete", defaultValue: "Delete", comment: "Delete button for stash")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_stash.failed", defaultValue: "Failed to delete", comment: "Error title when stash deletion fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.delete_stash.message", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Warning message for stash deletion"))
        }
        .confirmationDialog(
            String(format: String(localized: "source_control.delete_remote.title", defaultValue: "Do you want to delete the remote \"%@\"?", comment: "Confirmation title for deleting remote (remote name)"), remoteToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source_control.delete_remote.delete", defaultValue: "Delete", comment: "Delete button for remote")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_remote.failed", defaultValue: "Failed to delete", comment: "Error title when remote deletion fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.delete_remote.message", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Warning message for remote deletion"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
