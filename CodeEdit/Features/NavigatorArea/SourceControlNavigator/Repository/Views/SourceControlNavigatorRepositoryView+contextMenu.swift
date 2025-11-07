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
        Button(String(
            localized: "source-control-repository.switch",
            defaultValue: "Switch...",
            comment: "Menu item to switch to a branch"
        )) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != "BranchesGroup"
            ? String(
                localized: "source-control-repository.new-branch",
                defaultValue: "New Branch...",
                comment: "Menu item to create a new branch"
            )
            : {
                let branchName = branch.name
                return String(
                    localized: "source-control-repository.new-branch-from",
                    defaultValue: "New Branch from \"\(branchName)\"...",
                    comment: "Menu item to create a new branch from specific branch"
                )
            }()
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != "BranchesGroup")
        Button(
            item.branch == nil
            ? String(
                localized: "source-control-repository.rename-branch",
                defaultValue: "Rename Branch...",
                comment: "Menu item to rename a branch"
            )
            : {
                let branchName = branch.name
                return String(
                    localized: "source-control-repository.rename-branch-name",
                    defaultValue: "Rename \"\(branchName)\"...",
                    comment: "Menu item to rename specific branch"
                )
            }()
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(
            localized: "source-control-repository.add-remote",
            defaultValue: "Add Existing Remote...",
            comment: "Menu item to add existing remote"
        )) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != "RemotesGroup")
        Divider()
        Button(String(
            localized: "source-control-repository.apply-stash",
            defaultValue: "Apply Stashed Changes...",
            comment: "Menu item to apply stashed changes"
        )) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(
            localized: "source-control-repository.delete",
            defaultValue: "Delete...",
            comment: "Menu item to delete item"
        )) {
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
