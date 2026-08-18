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
            ? String(localized: "source-control.navigator.repository.stash.apply-confirmation.title", defaultValue: "Do you want to apply stashed changes?", comment: "Confirmation dialog title for applying stashed changes")
            : String(localized: "source-control.navigator.repository.stash.apply-confirmation.uncommitted-changes", defaultValue: "The local repository has uncommitted changes.", comment: "Alert message indicating repository has uncommitted changes before applying stash"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source-control.navigator.repository.stash.apply", defaultValue: "Apply", comment: "Button title to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.navigator.repository.stash.apply-and-delete", defaultValue: "Apply and Delete", comment: "Button title to apply and delete a stash entry")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.navigator.repository.cancel", defaultValue: "Cancel", comment: "Button title to cancel source control repository destructive action dialogs"), role: .cancel) {}
            } else {
                Button(String(localized: "source-control.navigator.repository.okay", defaultValue: "Okay", comment: "Button title acknowledging the stash apply warning without taking action"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source-control.navigator.repository.stash.apply-warning.restore-modifications", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Warning text describing consequences of applying stashed changes"))
            : Text(String(localized: "source-control.navigator.repository.stash.apply-warning.commit-or-discard", defaultValue: "Try committing or discarding the changes.", comment: "Guidance text after stash apply warning"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.navigator.repository.branch.delete-confirmation.title", defaultValue: "Do you want to delete the branch “%@”?", comment: "Confirmation dialog title for deleting a branch"), "\(branchToDelete?.name ?? "")"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source-control.navigator.repository.delete", defaultValue: "Delete", comment: "Button title to confirm delete action")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.delete.failed", defaultValue: "Failed to delete", comment: "Error title shown when delete action fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.branch.delete-confirmation.message", defaultValue: "The branch will be removed from the repository. You can’t undo this action.", comment: "Warning message for branch deletion confirmation"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.navigator.repository.stash.delete-confirmation.title", defaultValue: "Do you want to delete the stash “%@”?", comment: "Confirmation dialog title for deleting a stash entry"), "\(stashEntryToDelete?.message ?? "")"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source-control.navigator.repository.delete", defaultValue: "Delete", comment: "Button title to confirm delete action")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.delete.failed", defaultValue: "Failed to delete", comment: "Error title shown when delete action fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.stash.delete-confirmation.message", defaultValue: "The stash will be removed from the repository. You can’t undo this action.", comment: "Warning message for stash deletion confirmation"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.navigator.repository.remote.delete-confirmation.title", defaultValue: "Do you want to delete the remote “%@”?", comment: "Confirmation dialog title for deleting a remote"), "\(remoteToDelete?.name ?? "")"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source-control.navigator.repository.delete", defaultValue: "Delete", comment: "Button title to confirm delete action")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.repository.remote.delete.failed", defaultValue: "Failed to delete", comment: "Error title shown when remote delete action fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.repository.remote.delete-confirmation.message", defaultValue: "The remote will be removed from the repository. You can’t undo this action.", comment: "Warning message for remote deletion confirmation"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
