//
//  SourceControlNavigatorRepositoriesView+outlineGroupData.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/29/23.
//

import SwiftUI

extension SourceControlNavigatorRepositoryView {
    var outlineGroupData: [RepoOutlineGroupItem] {
        [
            .init(
                id: String(localized: "source_control.navigator.branches_group.id", defaultValue: "BranchesGroup", comment: "Identifier for branches group in source control navigator"),
                label: String(localized: "source_control.navigator.branches_group.label", defaultValue: "Branches", comment: "Label for branches group in source control navigator"),
                image: .system(name: String(localized: "source_control.navigator.branches_group.icon", defaultValue: "externaldrive.fill", comment: "System icon name for branches group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.orderedLocalBranches.map { branch in
                        .init(
                            id: String(format: String(localized: "source_control.navigator.branch.id_format", defaultValue: "Branch%@", comment: "Identifier format for branch item (branch name)"), branch.name),
                            label: branch.name,
                            description: branch == sourceControlManager.currentBranch ? String(localized: "source_control.navigator.branch.current_marker", defaultValue: "(current)", comment: "Marker for current branch") : nil,
                            image: .symbol(name: String(localized: "source_control.navigator.branch.icon", defaultValue: "branch", comment: "Symbol name for branch icon")),
                            imageColor: .blue,
                            branch: branch
                        )
                }
            ),
            .init(
                id: String(localized: "source_control.navigator.stashed_changes_group.id", defaultValue: "StashedChangesGroup", comment: "Identifier for stashed changes group in source control navigator"),
                label: String(localized: "source_control.navigator.stashed_changes_group.label", defaultValue: "Stashed Changes", comment: "Label for stashed changes group in source control navigator"),
                image: .system(name: String(localized: "source_control.navigator.stashed_changes_group.icon", defaultValue: "tray.2.fill", comment: "System icon name for stashed changes group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.stashEntries.map { stashEntry in
                        .init(
                            id: String(format: String(localized: "source_control.navigator.stash_entry.id_format", defaultValue: "StashEntry%d", comment: "Identifier format for stash entry (hash value)"), stashEntry.hashValue),
                            label: stashEntry.message,
                            description: stashEntry.date.formatted(
                                Date.FormatStyle()
                                    .year(.defaultDigits)
                                    .month(.abbreviated)
                                    .day(.twoDigits)
                                    .hour(.defaultDigits(amPM: .abbreviated))
                                    .minute(.twoDigits)
                            ),
                            image: .system(name: String(localized: "source_control.navigator.stash_entry.icon", defaultValue: "tray", comment: "System icon name for stash entry")),
                            imageColor: .orange,
                            stashEntry: stashEntry
                        )
                }
            ),
            .init(
                id: String(localized: "source_control.navigator.remotes_group.id", defaultValue: "RemotesGroup", comment: "Identifier for remotes group in source control navigator"),
                label: String(localized: "source_control.navigator.remotes_group.label", defaultValue: "Remotes", comment: "Label for remotes group in source control navigator"),
                image: .system(name: String(localized: "source_control.navigator.remotes_group.icon", defaultValue: "network", comment: "System icon name for remotes group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.remotes.map { remote in
                        .init(
                            id: String(format: String(localized: "source_control.navigator.remote.id_format", defaultValue: "Remote%d", comment: "Identifier format for remote (hash value)"), remote.hashValue),
                            label: remote.name,
                            image: .symbol(name: String(localized: "source_control.navigator.remote.icon", defaultValue: "vault", comment: "Symbol name for remote icon")),
                            imageColor: .teal,
                            children: remote.branches.map { branch in
                                .init(
                                    id: String(format: String(localized: "source_control.navigator.remote_branch.id_format", defaultValue: "Remote%@-Branch%@", comment: "Identifier format for remote branch (remote name, branch name)"), remote.name, branch.name),
                                    label: branch.name,
                                    image: .symbol(name: String(localized: "source_control.navigator.branch.icon", defaultValue: "branch", comment: "Symbol name for branch icon")),
                                    imageColor: .blue,
                                    branch: branch
                                )
                            },
                            remote: remote
                        )
                }
            )
        ]
    }
}
