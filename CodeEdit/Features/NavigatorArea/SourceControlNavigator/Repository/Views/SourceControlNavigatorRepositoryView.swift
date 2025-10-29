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
            ? String(localized: "Do you want to apply stashed changes?", comment: "Alert title asking if user wants to apply stashed changes")
            : String(localized: "The local repository has uncommitted changes.", comment: "Alert title indicating the repository has uncommitted changes"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "Apply", comment: "Button to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "Apply and Delete", comment: "Button to apply and delete stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "Cancel", comment: "Button to cancel the operation"), role: .cancel) {}
            } else {
                Button(String(localized: "Okay", comment: "Button to acknowledge and dismiss the alert"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text("Applying the stashed changes will restore modifications to files in your local repository.", comment: "Alert message explaining that applying stashed changes will restore file modifications")
            : Text("Try committing or discarding the changes.", comment: "Alert message suggesting to commit or discard changes")
        }
        .confirmationDialog(
            String(localized: "Do you want to delete the branch "\(branchToDelete?.name ?? "")"?", comment: "Confirmation dialog asking if user wants to delete a branch"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "Delete", comment: "Button to delete the branch")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "Failed to delete", comment: "Error title when deletion fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text("The branch will be removed from the repository. You can't undo this action.", comment: "Warning message that branch deletion is permanent")
        }
        .confirmationDialog(
            String(localized: "Do you want to delete the stash "\(stashEntryToDelete?.message ?? "")"?", comment: "Confirmation dialog asking if user wants to delete a stash"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "Delete", comment: "Button to delete the stash")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "Failed to delete", comment: "Error title when deletion fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text("The stash will be removed from the repository. You can't undo this action.", comment: "Warning message that stash deletion is permanent")
        }
        .confirmationDialog(
            String(localized: "Do you want to delete the remote "\(remoteToDelete?.name ?? "")"?", comment: "Confirmation dialog asking if user wants to delete a remote"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "Delete", comment: "Button to delete the remote")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "Failed to delete", comment: "Error title when deletion fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text("The remote will be removed from the repository. You can't undo this action.", comment: "Warning message that remote deletion is permanent")
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
