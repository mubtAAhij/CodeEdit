//
//  SourceControlPullView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/28/24.
//

import SwiftUI

struct SourceControlPullView: View {
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject var sourceControlManager: SourceControlManager

    let gitConfig = GitConfigClient(shellClient: currentWorld.shellClient)

    @State var loading: Bool = false

    @State var preferRebaseWhenPulling: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    RemoteBranchPicker(
                        branch: $sourceControlManager.operationBranch,
                        remote: $sourceControlManager.operationRemote,
                        onSubmit: submit,
                        canCreateBranch: false
                    )
                } header: {
                    Text(String(
                        localized: "source-control.pull-view.pull-remote-changes-from",
                        defaultValue: "Pull remote changes from",
                        comment: "Title line for pull operation source selector"
                    ))
                }
                Section {
                    Toggle(String(
                        localized: "source-control.pull-view.rebase-local-changes",
                        defaultValue: "Rebase local changes onto upstream changes",
                        comment: "Toggle description for rebasing local changes when pulling"
                    ), isOn: $sourceControlManager.operationRebase)
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .onAppear {
                Task {
                    preferRebaseWhenPulling = try await gitConfig.get(key: "pull.rebase", global: true) ?? false
                    if preferRebaseWhenPulling {
                        sourceControlManager.operationRebase = true
                    }
                }
            }
            HStack {
                if loading {
                    HStack(spacing: 7.5) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                        Text(String(
                            localized: "source-control.pull-view.pulling-changes",
                            defaultValue: "Pulling changes...",
                            comment: "Progress status label during pull operation"
                        ))
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(
                        localized: "source-control.pull-view.cancel",
                        defaultValue: "Cancel",
                        comment: "Cancel button title in pull sheet"
                    ))
                        .frame(minWidth: 56)
                }
                .disabled(loading)
                Button(action: submit) {
                    Text(String(
                        localized: "source-control.pull-view.pull",
                        defaultValue: "Pull",
                        comment: "Confirm button title to start pull"
                    ))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
                .disabled(loading)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(minWidth: 500)
    }

    /// Pulls changes from the specified remote and branch. If local changes exist, prompts user to stash them first
    func submit() {
        Task {
            do {
                if !sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.stashSheetIsPresented = true
                } else {
                    self.loading = true
                    try await sourceControlManager.pull(
                        remote: sourceControlManager.operationRemote?.name ?? nil,
                        branch: sourceControlManager.operationBranch?.name ?? nil,
                        rebase: sourceControlManager.operationRebase
                    )
                    self.loading = false
                    dismiss()
                }
            } catch {
                self.loading = false
                await sourceControlManager.showAlertForError(title: String(
                    localized: "source-control.pull-view.failed-to-pull",
                    defaultValue: "Failed to pull",
                    comment: "Error title shown when pull operation fails"
                ), error: error)
            }
        }
    }
}
