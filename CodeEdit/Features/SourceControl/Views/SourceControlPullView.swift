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
                    Text("source_control.pull.header", comment: "Section header")
                }
                Section {
                    Toggle("source_control.pull.rebase", comment: "Toggle label", isOn: $sourceControlManager.operationRebase)
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
                        Text("source_control.pull.pulling", comment: "Status message")
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("general.cancel", comment: "Button text")
                        .frame(minWidth: 56)
                }
                .disabled(loading)
                Button(action: submit) {
                    Text("source_control.pull.action", comment: "Button text")
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
                await sourceControlManager.showAlertForError(title: String(localized: "source_control.pull.failed", defaultValue: "Failed to pull", comment: "Error title"), error: error)
            }
        }
    }
}
