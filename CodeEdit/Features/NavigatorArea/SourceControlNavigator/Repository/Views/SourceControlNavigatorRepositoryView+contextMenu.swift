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
        Button(String(localized: "source-control.switch", defaultValue: "Switch...", comment: "Menu item to switch branch")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(localized: "source-control.new-branch", defaultValue: "New Branch...", comment: "Menu item to create new branch")
            : String(format: String(localized: "source-control.new-branch-from", defaultValue: "New Branch from \"%@\"...", comment: "Menu item to create new branch from existing branch"), branch.name)
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(localized: "source-control.rename-branch", defaultValue: "Rename Branch...", comment: "Menu item to rename branch")
            : String(format: String(localized: "source-control.rename-branch-name", defaultValue: "Rename \"%@\"...", comment: "Menu item to rename specific branch"), branch.name)
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "source-control.add-remote", defaultValue: "Add Existing Remote...", comment: "Menu item to add existing remote")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(localized: "source-control.apply-stash", defaultValue: "Apply Stashed Changes...", comment: "Menu item to apply stashed changes")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "source-control.delete", defaultValue: "Delete...", comment: "Menu item to delete item")) {
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
