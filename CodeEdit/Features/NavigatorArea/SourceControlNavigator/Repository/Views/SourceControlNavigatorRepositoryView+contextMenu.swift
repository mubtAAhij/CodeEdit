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
        Button(String(localized: "source-control.branch.switch", defaultValue: "Switch...", comment: "Menu item to switch to a branch")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(localized: "source-control.branch.new", defaultValue: "New Branch...", comment: "Menu item to create a new branch")
            : String(format: String(localized: "source-control.branch.new-from", defaultValue: "New Branch from \"%@\"...", comment: "Menu item to create a new branch from another branch"), branch.name)
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(localized: "source-control.branch.rename", defaultValue: "Rename Branch...", comment: "Menu item to rename a branch")
            : String(format: String(localized: "source-control.branch.rename-specific", defaultValue: "Rename \"%@\"...", comment: "Menu item to rename a specific branch"), branch.name)
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "source-control.remote.add-existing", defaultValue: "Add Existing Remote...", comment: "Menu item to add an existing remote repository")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(localized: "source-control.stash.apply", defaultValue: "Apply Stashed Changes...", comment: "Menu item to apply stashed changes")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "source-control.delete", defaultValue: "Delete...", comment: "Menu item to delete an item")) {
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
