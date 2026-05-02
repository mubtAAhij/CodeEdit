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
        Button(String(localized: "sourcecontrol.branch.switch", defaultValue: "Switch...", comment: "Switch branch button")) {
            sourceControlManager.switchToBranch = branch
        }
        .disabled(item.branch == nil || sourceControlManager.currentBranch == item.branch)
        Divider()
        Button(
            item.branch == nil && item.id != String(localized: "sourcecontrol.branches.group.id", defaultValue: "BranchesGroup", comment: "Branches group identifier")
            ? String(localized: "sourcecontrol.branch.new", defaultValue: "New Branch...", comment: "New branch button")
            : String(format: String(localized: "sourcecontrol.branch.new.from", defaultValue: "New Branch from \"%@\"...", comment: "New branch from existing button"), branch.name)
        ) {
            showNewBranch = true
            fromBranch =  item.branch
        }
        .disabled(item.branch == nil && item.id != String(localized: "sourcecontrol.branches.group.id.check", defaultValue: "BranchesGroup", comment: "Branches group identifier for checking"))
        Button(
            item.branch == nil
            ? String(localized: "sourcecontrol.branch.rename", defaultValue: "Rename Branch...", comment: "Rename branch button")
            : String(format: String(localized: "sourcecontrol.branch.rename.specific", defaultValue: "Rename \"%@\"...", comment: "Rename specific branch button"), branch.name)
        ) {
            showRenameBranch = true
            fromBranch = item.branch
        }
        .disabled(item.branch == nil || item.branch?.isRemote == true)
        Divider()
        Button(String(localized: "sourcecontrol.remote.add", defaultValue: "Add Existing Remote...", comment: "Add existing remote button")) {
            sourceControlManager.addExistingRemoteSheetIsPresented = true
        }
        .disabled(item.id != String(localized: "sourcecontrol.remotes.group.id", defaultValue: "RemotesGroup", comment: "Remotes group identifier"))
        Divider()
        Button(String(localized: "sourcecontrol.stash.apply", defaultValue: "Apply Stashed Changes...", comment: "Apply stashed changes button")) {
            applyStashedChangesIsPresented = true
            stashEntryToApply = item.stashEntry
        }
        .disabled(item.stashEntry == nil)
        Divider()
        Button(String(localized: "sourcecontrol.delete", defaultValue: "Delete...", comment: "Delete button")) {
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
