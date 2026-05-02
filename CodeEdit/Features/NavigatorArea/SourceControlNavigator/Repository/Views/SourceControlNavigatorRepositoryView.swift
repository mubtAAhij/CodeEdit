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
            ? String(localized: "source-control.stash.apply-prompt", defaultValue: "Do you want to apply stashed changes?", comment: "Alert title asking to apply stashed changes")
            : String(localized: "source-control.stash.uncommitted-changes", defaultValue: "The local repository has uncommitted changes.", comment: "Alert title about uncommitted changes"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source-control.stash.apply", defaultValue: "Apply", comment: "Button label to apply stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.stash.apply-and-delete", defaultValue: "Apply and Delete", comment: "Button label to apply and delete stashed changes")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control.cancel", defaultValue: "Cancel", comment: "Button label to cancel operation"), role: .cancel) {}
            } else {
                Button(String(localized: "source-control.okay", defaultValue: "Okay", comment: "Button label to acknowledge alert"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source-control.stash.apply-message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Alert message about applying stashed changes"))
            : Text(String(localized: "source-control.stash.uncommitted-changes-message", defaultValue: "Try committing or discarding the changes.", comment: "Alert message suggesting to commit or discard changes"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.branch.delete-prompt", defaultValue: "Do you want to delete the branch \"%@\"?", comment: "Confirmation dialog asking to delete branch"), branchToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source-control.delete", defaultValue: "Delete", comment: "Button label to delete item")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.failed-to-delete", defaultValue: "Failed to delete", comment: "Alert title for failed deletion"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.branch.delete-message", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Alert message about branch deletion consequences"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.stash.delete-prompt", defaultValue: "Do you want to delete the stash \"%@\"?", comment: "Confirmation dialog asking to delete stash"), stashEntryToDelete?.message ?? ""),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source-control.delete", defaultValue: "Delete", comment: "Button label to delete item")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.failed-to-delete", defaultValue: "Failed to delete", comment: "Alert title for failed deletion"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.stash.delete-message", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Alert message about stash deletion consequences"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control.remote.delete-prompt", defaultValue: "Do you want to delete the remote \"%@\"?", comment: "Confirmation dialog asking to delete remote"), remoteToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source-control.delete", defaultValue: "Delete", comment: "Button label to delete item")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control.failed-to-delete", defaultValue: "Failed to delete", comment: "Alert title for failed deletion"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control.remote.delete-message", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Alert message about remote deletion consequences"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
