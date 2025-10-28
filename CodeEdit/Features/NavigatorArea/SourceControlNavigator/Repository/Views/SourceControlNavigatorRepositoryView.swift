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
            ? String(localized: "source_control.apply_stash.title", comment: "Apply stash confirmation title")
            : String(localized: "source_control.uncommitted_changes.title", comment: "Uncommitted changes alert title"),
            isPresented: $applyStashedChangesIsPresented
        ) {
            if sourceControlManager.changedFiles.isEmpty {
                Button("source_control.apply_stash.apply", comment: "Apply stash button") {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button("source_control.apply_stash.apply_and_delete", comment: "Apply and delete stash button") {
                    if let stashEntry = stashEntryToApply {
                        Task {
                            try await sourceControlManager.applyStashEntry(stashEntry: stashEntry)
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                            applyStashedChangesIsPresented = false
                            stashEntryToApply = nil
                        }
                    }
                }
                Button("actions.cancel", comment: "Cancel button", role: .cancel) {}
            } else {
                Button("source_control.alert.okay", comment: "Okay button", role: .cancel) {}
            }
        } message: {
            sourceControlManager.changedFiles.isEmpty
            ? Text("source_control.apply_stash.message", comment: "Apply stash message")
            : Text("source_control.uncommitted_changes.message", comment: "Uncommitted changes message")
        }
        .confirmationDialog(
            String(localized: "source_control.delete_branch.title \(branchToDelete?.name ?? "")", comment: "Delete branch confirmation title"),
            isPresented: $isPresentingConfirmDeleteBranch
        ) {
            Button("actions.delete", comment: "Delete button") {
                if let branch = branchToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteBranch(branch: branch)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_branch.failed", comment: "Failed to delete branch"),
                                error: error
                            )
                        }
                        branchToDelete = nil
                    }
                }
            }
        } message: {
            Text("source_control.delete_branch.message", comment: "Delete branch warning message")
        }
        .confirmationDialog(
            String(localized: "source_control.delete_stash.title \(stashEntryToDelete?.message ?? "")", comment: "Delete stash confirmation title"),
            isPresented: $isPresentingConfirmDeleteStashEntry
        ) {
            Button("actions.delete", comment: "Delete button") {
                if let stashEntry = stashEntryToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteStashEntry(stashEntry: stashEntry)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_stash.failed", comment: "Failed to delete stash"),
                                error: error
                            )
                        }
                        stashEntryToDelete = nil
                    }
                }
            }
        } message: {
            Text("source_control.delete_stash.message", comment: "Delete stash warning message")
        }
        .confirmationDialog(
            String(localized: "source_control.delete_remote.title \(remoteToDelete?.name ?? "")", comment: "Delete remote confirmation title"),
            isPresented: $isPresentingConfirmDeleteRemote
        ) {
            Button("actions.delete", comment: "Delete button") {
                if let remote = remoteToDelete {
                    Task {
                        do {
                            try await sourceControlManager.deleteRemote(remote: remote)
                        } catch {
                            await sourceControlManager.showAlertForError(
                                title: String(localized: "source_control.delete_remote.failed", comment: "Failed to delete remote"),
                                error: error
                            )
                        }
                        remoteToDelete = nil
                    }
                }
            }
        } message: {
            Text("source_control.delete_remote.message", comment: "Delete remote warning message")
        }
        .task {
            await sourceControlManager.refreshBranches()
        }
    }
}
