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
                id: "BranchesGroup",
                label: String(localized: "source_control.outline.branches", comment: "Section header for branches in source control navigator"),
                image: .system(name: "externaldrive.fill"),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.orderedLocalBranches.map { branch in
                        .init(
                            id: "Branch\(branch.name)",
                            label: branch.name,
                            description: branch == sourceControlManager.currentBranch ? String(localized: "source_control.outline.current_branch", comment: "Label indicating the current branch") : nil,
                            image: .symbol(name: "branch"),
                            imageColor: .blue,
                            branch: branch
                        )
                }
            ),
            .init(
                id: "StashedChangesGroup",
                label: String(localized: "source_control.outline.stashed_changes", comment: "Section header for stashed changes in source control navigator"),
                image: .system(name: "tray.2.fill"),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.stashEntries.map { stashEntry in
                        .init(
                            id: "StashEntry\(stashEntry.hashValue)",
                            label: stashEntry.message,
                            description: stashEntry.date.formatted(
                                Date.FormatStyle()
                                    .year(.defaultDigits)
                                    .month(.abbreviated)
                                    .day(.twoDigits)
                                    .hour(.defaultDigits(amPM: .abbreviated))
                                    .minute(.twoDigits)
                            ),
                            image: .system(name: "tray"),
                            imageColor: .orange,
                            stashEntry: stashEntry
                        )
                }
            ),
            .init(
                id: "RemotesGroup",
                label: String(localized: "source_control.outline.remotes", comment: "Section header for remote repositories in source control navigator"),
                image: .system(name: "network"),
                imageColor: Color(nsColor: .secondaryLabelColor),
                children: sourceControlManager.remotes.map { remote in
                        .init(
                            id: "Remote\(remote.hashValue)",
                            label: remote.name,
                            image: .symbol(name: "vault"),
                            imageColor: .teal,
                            children: remote.branches.map { branch in
                                .init(
                                    id: "Remote\(remote.name)-Branch\(branch.name)",
                                    label: branch.name,
                                    image: .symbol(name: "branch"),
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
