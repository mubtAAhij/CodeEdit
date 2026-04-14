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
            ? String(localized: "apply-stashed-changes-confirm", defaultValue: "Do you want to apply stashed changes?", comment: "Apply stashed changes confirmation title", os_id: "102254")
            : String(localized: "uncommitted-changes-warning", defaultValue: "The local repository has uncommitted changes.", comment: "Uncommitted changes warning title", os_id: "102255"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button(String(localized: "apply", defaultValue: "Apply", comment: "Apply button", os_id: "102256")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "apply-and-delete", defaultValue: "Apply and Delete", comment: "Apply and delete button", os_id: "102257")) {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button"), role: .cancel) {}
            } else {
                Button(String(localized: "okay", defaultValue: "Okay", comment: "Okay button", os_id: "102258"), role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text(String(localized: "apply-stashed-changes-message", defaultValue: "Applying the stashed changes will restore modifications to files in your local repository.", comment: "Apply stashed changes message", os_id: "102259"))
            : Text(String(localized: "try-committing-or-discarding", defaultValue: "Try committing or discarding the changes.", comment: "Try committing or discarding message", os_id: "102260"))
        }
        .confirmationDialog(
            "Do you want to delete the branch \"\(branchToDelete?.name ?? "")\"?",
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button(String(localized: "delete", defaultValue: "Delete", comment: "Delete button")) {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error title"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "delete-branch-warning", defaultValue: "The branch will be removed from the repository. You can't undo this action.", comment: "Delete branch warning message", os_id: "102262"))
        }
        .confirmationDialog(
            "Do you want to delete the stash \"\(stashEntryToDelete?.message ?? "")\"?",
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button(String(localized: "delete", defaultValue: "Delete", comment: "Delete button")) {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error title"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "delete-stash-warning", defaultValue: "The stash will be removed from the repository. You can't undo this action.", comment: "Delete stash warning message", os_id: "102263"))
        }
        .confirmationDialog(
            "Do you want to delete the remote \"\(remoteToDelete?.name ?? "")\"?",
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button(String(localized: "delete", defaultValue: "Delete", comment: "Delete button")) {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "failed-to-delete", defaultValue: "Failed to delete", comment: "Failed to delete error title", os_id: "102261"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text(String(localized: "delete-remote-warning", defaultValue: "The remote will be removed from the repository. You can't undo this action.", comment: "Delete remote warning message", os_id: "102264"))
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
