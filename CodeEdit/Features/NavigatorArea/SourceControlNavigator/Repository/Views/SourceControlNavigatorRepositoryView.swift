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
            ? String(localized: "source-control.navigator.apply-stash-title", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title for applying stashed changes")
            : String(localized: "source-control.navigator.uncommitted-changes-title", defaultValue: "The local repository has uncommitted changes.", comment: "Alert title when repository has uncommitted changes"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source-control.navigator.apply-button", defaultValue: "Apply", comment: "Button to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.navigator.apply-and-delete-button", defaultValue: "Apply and Delete", comment: "Button to apply and delete stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "button.cancel", defaultValue: "Cancel", comment: "Cancel button"), role: .cancel) {}
            } else {
                Button(String(localized: "button.okay", defaultValue: "Okay", comment: "Okay button"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source-control.navigator.apply-stash-message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Message explaining apply stash action"))
            : Text(String(localized: "source-control.navigator.uncommitted-changes-message", defaultValue: "Try committing or discarding the changes.", comment: "Message when there are uncommitted changes"))
        }
        .confirmationDialog(
            String(localized: "source-control.navigator.delete-branch-title", defaultValue: "Do you want to delete the branch \"\(branchToDelete?.name ?? \"\")\"?", comment: "Confirmation dialog title for deleting branch"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "button.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.error.delete-failed", defaultValue: "Failed to delete", comment: "Error title when delete fails"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.delete-branch-message", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Message warning about deleting branch"))
        }
        .confirmationDialog(
            String(localized: "source-control.navigator.delete-stash-title", defaultValue: "Do you want to delete the stash \"\(stashEntryToDelete?.message ?? \"\")\"?", comment: "Confirmation dialog title for deleting stash"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "button.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.error.delete-failed", defaultValue: "Failed to delete", comment: "Error title when delete fails"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.delete-stash-message", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Message warning about deleting stash"))
        }
        .confirmationDialog(
            String(localized: "source-control.navigator.delete-remote-title", defaultValue: "Do you want to delete the remote \"\(remoteToDelete?.name ?? \"\")\"?", comment: "Confirmation dialog title for deleting remote"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "button.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.navigator.error.delete-failed", defaultValue: "Failed to delete", comment: "Error title when delete fails"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.navigator.delete-remote-message", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Message warning about deleting remote"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
