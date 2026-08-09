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
            ? String(localized: "source-control.navigator.repository.alert.apply-stash.title", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title asking whether to apply stashed changes")
            : String(localized: "source-control.navigator.repository.alert.apply-stash-uncommitted.message", defaultValue: "The local repository has uncommitted changes.", comment: "Alert message indicating uncommitted changes exist"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source-control.navigator.repository.action.apply", defaultValue: "Apply", comment: "Button title to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.navigator.repository.action.apply-and-delete", defaultValue: "Apply and Delete", comment: "Button title to apply stashed changes and delete stash")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.navigator.repository.action.cancel", defaultValue: "Cancel", comment: "Cancel button title in repository alert"), role: .cancel) {}
            } else {
                Button(String(localized: "source-control.navigator.repository.action.okay", defaultValue: "Okay", comment: "Confirmation button title in repository alert"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source-control.navigator.repository.alert.apply-stash.description", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Alert explanation of applying stashed changes"))
            : Text(String(localized: "source-control.navigator.repository.alert.apply-stash.suggestion", defaultValue: "Try committing or discarding the changes.", comment: "Alert suggestion to commit or discard local changes"))
        }
        .confirmationDialog(
            "Do you want to delete the branch “\(branchToDelete?.name ?? "")”?",
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source-control.navigator.repository.action.delete", defaultValue: "Delete", comment: "Destructive button title to delete a branch")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.error.delete.failed.branch", defaultValue: "Failed to delete", comment: "Error title when branch deletion fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.alert.delete-branch.message", defaultValue: "The branch will be removed from the repository. You can’t undo this action.", comment: "Warning message for deleting a branch"))
        }
        .confirmationDialog(
            "Do you want to delete the stash “\(stashEntryToDelete?.message ?? "")”?",
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source-control.navigator.repository.action.delete.stash", defaultValue: "Delete", comment: "Destructive button title to delete stash")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.error.delete.failed.stash", defaultValue: "Failed to delete", comment: "Error title when stash deletion fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.alert.delete-stash.message", defaultValue: "The stash will be removed from the repository. You can’t undo this action.", comment: "Warning message for deleting a stash"))
        }
        .confirmationDialog(
            "Do you want to delete the remote “\(remoteToDelete?.name ?? "")”?",
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source-control.navigator.repository.action.delete.remote", defaultValue: "Delete", comment: "Destructive button title to delete remote")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.error.delete.failed.remote", defaultValue: "Failed to delete", comment: "Error title when remote deletion fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.alert.delete-remote.message", defaultValue: "The remote will be removed from the repository. You can’t undo this action.", comment: "Warning message for deleting a remote"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
