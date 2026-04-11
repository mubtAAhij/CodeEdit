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
            ? String(localized: "sourcecontrol.stash.apply-prompt", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title asking if user wants to apply stashed changes")
            : String(localized: "sourcecontrol.stash.uncommitted-changes", defaultValue: "The local repository has uncommitted changes.", comment: "Alert title when repository has uncommitted changes"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "sourcecontrol.stash.apply", defaultValue: "Apply", comment: "Button to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "sourcecontrol.stash.apply-and-delete", defaultValue: "Apply and Delete", comment: "Button to apply stashed changes and delete the stash")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "sourcecontrol.stash.cancel", defaultValue: "Cancel", comment: "Cancel button in stash apply dialog"), role: .cancel) {}
            } else {
                Button(String(localized: "sourcecontrol.stash.okay", defaultValue: "Okay", comment: "OK button when uncommitted changes exist"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "sourcecontrol.stash.apply-message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Message explaining what happens when applying stashed changes"))
            : Text(String(localized: "sourcecontrol.stash.uncommitted-message", defaultValue: "Try committing or discarding the changes.", comment: "Message suggesting user commit or discard changes"))
        }
        .confirmationDialog(
            String(format: String(localized: "sourcecontrol.branch.delete-prompt", defaultValue: "Do you want to delete the branch \"%@\"?", comment: "Confirmation prompt for deleting a branch"), branchToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "sourcecontrol.branch.delete", defaultValue: "Delete", comment: "Button to delete a branch")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.branch.delete-failed", defaultValue: "Failed to delete", comment: "Error title when branch deletion fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "sourcecontrol.branch.delete-message", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Warning message for branch deletion"))
        }
        .confirmationDialog(
            String(format: String(localized: "sourcecontrol.stash.delete-prompt", defaultValue: "Do you want to delete the stash \"%@\"?", comment: "Confirmation prompt for deleting a stash"), stashEntryToDelete?.message ?? ""),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "sourcecontrol.stash.delete", defaultValue: "Delete", comment: "Button to delete a stash")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.stash.delete-failed", defaultValue: "Failed to delete", comment: "Error title when stash deletion fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "sourcecontrol.stash.delete-message", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Warning message for stash deletion"))
        }
        .confirmationDialog(
            String(format: String(localized: "sourcecontrol.remote.delete-prompt", defaultValue: "Do you want to delete the remote \"%@\"?", comment: "Confirmation prompt for deleting a remote"), remoteToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "sourcecontrol.remote.delete", defaultValue: "Delete", comment: "Button to delete a remote")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.remote.delete-failed", defaultValue: "Failed to delete", comment: "Error title when remote deletion fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "sourcecontrol.remote.delete-message", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Warning message for remote deletion"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
