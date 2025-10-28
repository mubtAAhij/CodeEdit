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
            ? String(localized: "sourcecontrol.alert.apply_stash", comment: "Alert title")
            : String(localized: "sourcecontrol.alert.uncommitted_changes", comment: "Alert title"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button("sourcecontrol.button.apply", comment: "Apply stash button") {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button("sourcecontrol.button.apply_and_delete", comment: "Apply and delete stash button") {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button("actions.cancel", comment: "Cancel button") {}
            } else {
                Button("sourcecontrol.button.okay", comment: "Okay button") {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text("sourcecontrol.message.apply_stash_description", comment: "Alert message")
            : Text("sourcecontrol.message.try_committing", comment: "Alert message")
        }
        .confirmationDialog(
            String(localized: "sourcecontrol.dialog.delete_branch \(branchToDelete?.name ?? "")", comment: "Delete branch confirmation"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button("sourcecontrol.button.delete", comment: "Delete button") {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.error.failed_to_delete", comment: "Failed to delete error title"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text("sourcecontrol.message.delete_branch_warning", comment: "Delete branch warning")
        }
        .confirmationDialog(
            String(localized: "sourcecontrol.dialog.delete_stash \(stashEntryToDelete?.message ?? "")", comment: "Delete stash confirmation"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button("sourcecontrol.button.delete", comment: "Delete button") {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.error.failed_to_delete", comment: "Failed to delete error title"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text("sourcecontrol.message.delete_stash_warning", comment: "Delete stash warning")
        }
        .confirmationDialog(
            String(localized: "sourcecontrol.dialog.delete_remote \(remoteToDelete?.name ?? "")", comment: "Delete remote confirmation"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button("sourcecontrol.button.delete", comment: "Delete button") {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "sourcecontrol.error.failed_to_delete", comment: "Failed to delete error title"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text("sourcecontrol.message.delete_remote_warning", comment: "Delete remote warning")
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
