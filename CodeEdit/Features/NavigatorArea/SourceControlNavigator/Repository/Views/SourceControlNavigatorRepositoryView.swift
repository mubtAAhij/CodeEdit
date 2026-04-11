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
            ? String(localized: "source-control-navigator-repository.apply-stashed-changes", defaultValue: "Do you want to apply stashed changes?", comment: "Apply stashed changes alert title")
            : String(localized: "source-control-navigator-repository.uncommitted-changes", defaultValue: "The local repository has uncommitted changes.", comment: "Uncommitted changes alert title"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "source-control-navigator-repository.apply", defaultValue: "Apply", comment: "Apply button")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control-navigator-repository.apply-and-delete", defaultValue: "Apply and Delete", comment: "Apply and delete button")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "source-control-navigator-repository.cancel", defaultValue: "Cancel", comment: "Cancel button"), role: .cancel) {}
            } else {
                Button(String(localized: "source-control-navigator-repository.okay", defaultValue: "Okay", comment: "Okay button"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "source-control-navigator-repository.apply-stashed-message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Apply stashed changes message"))
            : Text(String(localized: "source-control-navigator-repository.uncommitted-changes-message", defaultValue: "Try committing or discarding the changes.", comment: "Uncommitted changes message"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control-navigator-repository.delete-branch-title", defaultValue: "Do you want to delete the branch \"%@\"?", comment: "Delete branch confirmation title"), branchToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "source-control-navigator-repository.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control-navigator-repository.failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control-navigator-repository.delete-branch-message", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Delete branch message"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control-navigator-repository.delete-stash-title", defaultValue: "Do you want to delete the stash \"%@\"?", comment: "Delete stash confirmation title"), stashEntryToDelete?.message ?? ""),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "source-control-navigator-repository.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control-navigator-repository.failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control-navigator-repository.delete-stash-message", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Delete stash message"))
        }
        .confirmationDialog(
            String(format: String(localized: "source-control-navigator-repository.delete-remote-title", defaultValue: "Do you want to delete the remote \"%@\"?", comment: "Delete remote confirmation title"), remoteToDelete?.name ?? ""),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "source-control-navigator-repository.delete", defaultValue: "Delete", comment: "Delete button")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source-control-navigator-repository.failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "source-control-navigator-repository.delete-remote-message", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Delete remote message"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
