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
            ? String(localized: "source_control.navigator.repository.stash.apply.confirmation.title", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title asking whether to apply stashed changes")
            : String(localized: "source_control.navigator.repository.stash.apply.warning.uncommitted-changes", defaultValue: "The local repository has uncommitted changes.", comment: "Alert message indicating uncommitted changes exist before applying stash"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source_control.navigator.repository.stash.apply.action.apply", defaultValue: "Apply", comment: "Primary action button to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source_control.navigator.repository.stash.apply.action.apply-and-delete", defaultValue: "Apply and Delete", comment: "Action button to apply stashed changes and delete stash entry")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source_control.navigator.repository.alert.cancel", defaultValue: "Cancel", comment: "Cancel button title in source control repository alerts"), role: .cancel) {}
            } else {
                Button(String(localized: "source_control.navigator.repository.alert.okay", defaultValue: "Okay", comment: "Acknowledgement button title in source control repository alerts"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source_control.navigator.repository.stash.apply.info.restore-modifications", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Informational message explaining effect of applying stashed changes"))
            : Text(String(localized: "source_control.navigator.repository.stash.apply.info.commit-or-discard", defaultValue: "Try committing or discarding the changes.", comment: "Guidance message suggesting commit or discard before applying stash"))
        }
        .confirmationDialog(
            "Do you want to delete the branch “\(branchToDelete?.name ?? "")”?",
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source_control.navigator.repository.branch.delete.action.delete", defaultValue: "Delete", comment: "Destructive action button title to delete a branch")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.navigator.repository.delete.error.title", defaultValue: "Failed to delete", comment: "Error title shown when deleting a repository item fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.navigator.repository.branch.delete.warning", defaultValue: "The branch will be removed from the repository. You can’t undo this action.", comment: "Warning message shown before deleting a branch"))
        }
        .confirmationDialog(
            "Do you want to delete the stash “\(stashEntryToDelete?.message ?? "")”?",
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source_control.navigator.repository.stash.delete.action.delete", defaultValue: "Delete", comment: "Destructive action button title for deleting a stash entry")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.navigator.repository.delete.error.title", defaultValue: "Failed to delete", comment: "Error title shown when deleting a repository item fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.navigator.repository.stash.delete.warning", defaultValue: "The stash will be removed from the repository. You can’t undo this action.", comment: "Warning message shown before deleting a stash entry"))
        }
        .confirmationDialog(
            "Do you want to delete the remote “\(remoteToDelete?.name ?? "")”?",
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source_control.navigator.repository.remote.delete.action.delete", defaultValue: "Delete", comment: "Destructive action button title for deleting a remote")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.navigator.repository.delete.error.title", defaultValue: "Failed to delete", comment: "Error title shown when deleting a repository item fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source_control.navigator.repository.remote.delete.warning", defaultValue: "The remote will be removed from the repository. You can’t undo this action.", comment: "Warning message shown before deleting a remote"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
