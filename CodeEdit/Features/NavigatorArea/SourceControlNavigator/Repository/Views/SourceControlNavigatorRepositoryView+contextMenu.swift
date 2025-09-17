//
//  SourceControlNavigatorRepositoriesView+contextMenu.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/29/23.
//

import SwiftUI

extension SourceControlNavigatorRepositoryView {
    func handleDelete(_ item: RepoOutlineGroupItem) {
        if item.branch != nil {
            isPresentingConfirmDeleteBranch = true
            branchToDelete = item.branch
        }
        if item.stashEntry != nil {
            isPresentingConfirmDeleteStashEntry = true
            stashEntryToDelete = item.stashEntry
        }
        if item.remote != nil {
            isPresentingConfirmDeleteRemote = true
            remoteToDelete = item.remote
        }
    }

    @ViewBuilder
    func contextMenu(for item: RepoOutlineGroupItem, branch: GitBranch) -> some View {
        Button(String(localized: "switch_branch", comment: "Context menu item to switch branch")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(localized: "new_branch", comment: "Context menu item to create new branch")
            : String(localized: "new_branch_from_branch", arguments: [branch.name], comment: "Context menu item to create new branch from existing branch")
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(localized: "rename_branch", comment: "Context menu item to rename branch")
            : "String(localized: "rename_branch_format", arguments: [branch.name])"
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "add_existing_remote", comment: "Context menu option to add existing remote")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(localized: "apply_stashed_changes", comment: "Context menu option to apply stashed changes")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "delete_ellipsis", comment: "Context menu option to delete item")) {
            handleDelete(item)
        }
        .disabled(
            (item.branch == nil
             || item.branch?.isLocal == false
             || sourceControlManager.currentBranch == item.branch)
            && item.stashEntry == nil
            && item.remote == nil
        )
    }
}
