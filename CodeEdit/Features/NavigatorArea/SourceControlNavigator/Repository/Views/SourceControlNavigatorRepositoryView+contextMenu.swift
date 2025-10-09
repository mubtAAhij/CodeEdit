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
        Button(String(localized: "source_control.context_menu.switch", comment: "Context menu option to switch to a branch")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(localized: "source_control.context_menu.new_branch", comment: "Context menu option to create a new branch")
            : "New Branch from \"\(branch.name)\"..."
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(localized: "source_control.context_menu.rename_branch", comment: "Context menu option to rename a branch")
            : "Rename \"\(branch.name)\"..."
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "source_control.context_menu.add_existing_remote", comment: "Context menu option to add an existing remote repository")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(localized: "source_control.context_menu.apply_stashed_changes", comment: "Context menu option to apply stashed changes")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "source_control.context_menu.delete", comment: "Context menu option to delete an item")) {
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
