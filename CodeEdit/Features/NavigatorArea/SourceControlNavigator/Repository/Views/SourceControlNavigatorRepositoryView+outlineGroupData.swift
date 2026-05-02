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
                id: String(localized: "source.control.navigator.branches.group.id", defaultValue: "BranchesGroup", comment: "Identifier for branches group in source control navigator"),
                label: String(localized: "source.control.navigator.branches.label", defaultValue: "Branches", comment: "Label for branches section in source control navigator"),
                image: .system(name: String(localized: "source.control.navigator.branches.icon", defaultValue: "externaldrive.fill", comment: "System icon name for branches group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.orderedLocalBranches.map { branch in
                        .init(
                            id: String(format: String(localized: "source.control.navigator.branch.id.format", defaultValue: "Branch%@", comment: "Format for branch identifier in source control navigator"), branch.name),
                            label: branch.name,
                            description: branch == sourceControlManager.currentBranch ? String(localized: "source.control.navigator.branch.current", defaultValue: "(current)", comment: "Label indicating current branch in source control navigator") : nil,
                            image: .symbol(name: String(localized: "source.control.navigator.branch.icon", defaultValue: "branch", comment: "Symbol icon name for branch")),
                            imageColor: .blue,
                            branch: branch
                        )
                }
            ),
            .init(
                id: String(localized: "source.control.navigator.stashed.changes.group.id", defaultValue: "StashedChangesGroup", comment: "Identifier for stashed changes group in source control navigator"),
                label: String(localized: "source.control.navigator.stashed.changes.label", defaultValue: "Stashed Changes", comment: "Label for stashed changes section in source control navigator"),
                image: .system(name: String(localized: "source.control.navigator.stashed.changes.icon", defaultValue: "tray.2.fill", comment: "System icon name for stashed changes group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.stashEntries.map { stashEntry in
                        .init(
                            id: String(format: String(localized: "source.control.navigator.stash.entry.id.format", defaultValue: "StashEntry%d", comment: "Format for stash entry identifier in source control navigator"), stashEntry.hashValue),
                            label: stashEntry.message,
                            description: stashEntry.date.formatted(
                                Date.FormatStyle()
                                    .year(.defaultDigits)
                                    .month(.abbreviated)
                                    .day(.twoDigits)
                                    .hour(.defaultDigits(amPM: .abbreviated))
                                    .minute(.twoDigits)
                            ),
                            image: .system(name: String(localized: "source.control.navigator.stash.entry.icon", defaultValue: "tray", comment: "System icon name for stash entry")),
                            imageColor: .orange,
                            stashEntry: stashEntry
                        )
                }
            ),
            .init(
                id: String(localized: "source.control.navigator.remotes.group.id", defaultValue: "RemotesGroup", comment: "Identifier for remotes group in source control navigator"),
                label: String(localized: "source.control.navigator.remotes.label", defaultValue: "Remotes", comment: "Label for remotes section in source control navigator"),
                image: .system(name: String(localized: "source.control.navigator.remotes.icon", defaultValue: "network", comment: "System icon name for remotes group")),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.remotes.map { remote in
                        .init(
                            id: String(format: String(localized: "source.control.navigator.remote.id.format", defaultValue: "Remote%d", comment: "Format for remote identifier in source control navigator"), remote.hashValue),
                            label: remote.name,
                            image: .symbol(name: String(localized: "source.control.navigator.remote.icon", defaultValue: "vault", comment: "Symbol icon name for remote")),
                            imageColor: .teal,
                            children: remote.branches.map { branch in
                                .init(
                                    id: String(format: String(localized: "source.control.navigator.remote.branch.id.format", defaultValue: "Remote%@-Branch%@", comment: "Format for remote branch identifier in source control navigator"), remote.name, branch.name),
                                    label: branch.name,
                                    image: .symbol(name: String(localized: "source.control.navigator.remote.branch.icon", defaultValue: "branch", comment: "Symbol icon name for remote branch")),
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
