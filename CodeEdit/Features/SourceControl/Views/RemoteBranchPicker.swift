//
//  RemoteBranchPicker.swift
//  CodeEdit
//
//  Created by Austin Condiff on 7/1/24.
//

import SwiftUI

struct RemoteBranchPicker: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager

    @Binding var branch: GitBranch?
    @Binding var remote: GitRemote?

    let onSubmit: () -> Void
    let canCreateBranch: Bool

    var shouldCreateBranch: Bool {
        canCreateBranch && !(remote?.branches.contains(
            where: { $0.name == (sourceControlManager.currentBranch?.name ?? "") }
        ) ?? true)
    }

    var body: some View {
        Group {
            Picker(selection: $remote) {
                ForEach(sourceControlManager.remotes, id: \.name) { remote in
                    Label {
                        Text(remote.name)
                    } icon: {
                        Image(symbol: "vault")
                    }
                    .tag(remote as GitRemote?)
                }
                Divider()
                Text(String(localized: "source-control.add-existing-remote", defaultValue: "Add Existing Remote...", comment: "Add existing remote option"))
                    .tag(GitRemote?(nil))
            } label: {
                Text(String(localized: "source-control.remote", defaultValue: "Remote", comment: "Remote label"))
            }
            Picker(selection: $branch) {
                if shouldCreateBranch {
                    Label {
                        Text(String(format: NSLocalizedString("source-control.branch-create", comment: "Branch create format"), sourceControlManager.currentBranch?.name ?? ""))
                    } icon: {
                        Image(symbol: "branch")
                    }
                    .tag(sourceControlManager.currentBranch)
                }
                if let branches = remote?.branches, !branches.isEmpty {
                    ForEach(branches, id: \.longName) { branch in
                        Label {
                            Text(branch.name)
                        } icon: {
                            Image(symbol: "branch")
                        }
                        .tag(branch as GitBranch?)
                    }
                }
            } label: {
                Text(String(localized: "source-control.branch", defaultValue: "Branch", comment: "Branch label"))
            }
        }
        .onAppear {
            if remote == nil {
                updateRemote()
            }
        }
        .onChange(of: remote) { _, newValue in
            if newValue == nil {
                sourceControlManager.addExistingRemoteSheetIsPresented = true
            } else {
                updateBranch()
            }
        }
    }

    private func updateRemote() {
        if let currentBranch = sourceControlManager.currentBranch, let upstream = currentBranch.upstream {
            self.remote = sourceControlManager.remotes.first(where: { upstream.starts(with: $0.name) })
        } else {
            self.remote = sourceControlManager.remotes.first
        }
    }

    private func updateBranch() {
        if shouldCreateBranch {
            self.branch = sourceControlManager.currentBranch
        } else if let currentBranch = sourceControlManager.currentBranch,
            let upstream = currentBranch.upstream,
            let remote = self.remote,
            let branchIndex = remote.branches.firstIndex(where: { upstream.contains($0.name) }) {
            self.branch = remote.branches[branchIndex]
        } else {
            self.branch = remote?.branches.first
        }
    }
}
