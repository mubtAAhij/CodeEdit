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
        Button(String(localized: "source-control.repository.context-menu.switch", defaultValue: "Switch...", comment: "Context menu action to switch branches.")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(localized: "source-control.repository.context-menu.new-branch", defaultValue: "New Branch...", comment: "Context menu action to create a new branch.")
            : String(format: String(localized: "source-control.repository.context-menu.new-branch-from", defaultValue: "New Branch from \"%@\"...", comment: "Context menu action to create a new branch from a selected branch."), "\(branch.name)")
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(localized: "source-control.repository.context-menu.rename-branch", defaultValue: "Rename Branch...", comment: "Context menu action to rename a branch.")
            : String(format: String(localized: "source-control.repository.context-menu.rename-branch-name", defaultValue: "Rename \"%@\"...", comment: "Context menu action to rename the selected branch."), "\(branch.name)")
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "source-control.repository.context-menu.add-existing-remote", defaultValue: "Add Existing Remote...", comment: "Context menu action to add an existing remote.")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(localized: "source-control.repository.context-menu.apply-stashed-changes", defaultValue: "Apply Stashed Changes...", comment: "Context menu action to apply stashed changes.")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "source-control.repository.context-menu.delete", defaultValue: "Delete...", comment: "Context menu action to delete selected source control item.")) {
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
