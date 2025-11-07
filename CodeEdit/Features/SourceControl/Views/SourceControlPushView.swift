//
//  SourceControlPushView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/26/24.
//

import SwiftUI

struct SourceControlPushView: View {
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State var loading: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    RemoteBranchPicker(
                        branch: $sourceControlManager.operationBranch,
                        remote: $sourceControlManager.operationRemote,
                        onSubmit: submit,
                        canCreateBranch: true
                    )
                } header: {
                    Text(String(
                        localized: "source-control.push.header",
                        defaultValue: "Push local changes to",
                        comment: "Section header for push destination"
                    ))
                }
                Section {
                    Toggle(String(
                        localized: "source-control.push.force",
                        defaultValue: "Force",
                        comment: "Toggle to force push changes"
                    ), isOn: $sourceControlManager.operationForce)
                    Toggle(String(
                        localized: "source-control.push.include-tags",
                        defaultValue: "Include Tags",
                        comment: "Toggle to include tags in push"
                    ), isOn: $sourceControlManager.operationIncludeTags)
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            HStack {
                if loading {
                    HStack(spacing: 7.5) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                        Text(String(
                            localized: "source-control.push.pushing",
                            defaultValue: "Pushing changes...",
                            comment: "Progress message while pushing changes"
                        ))
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(
                        localized: "source-control.push.cancel",
                        defaultValue: "Cancel",
                        comment: "Button to cancel push operation"
                    ))
                        .frame(minWidth: 56)
                }
                .disabled(loading)
                Button(action: submit) {
                    Text(String(
                        localized: "source-control.push.push",
                        defaultValue: "Push",
                        comment: "Button to push changes"
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

    /// Pushes commited changes to specified remote and branch
    func submit() {
        Task {
            do {
                self.loading = true
                try await sourceControlManager.push(
                    remote: sourceControlManager.operationRemote?.name ?? nil,
                    branch: sourceControlManager.operationBranch?.name ?? nil,
                    setUpstream: sourceControlManager.currentBranch?.upstream == nil,
                    force: sourceControlManager.operationForce,
                    tags: sourceControlManager.operationIncludeTags
                )
                self.loading = false
                dismiss()
            } catch {
                self.loading = false
                await sourceControlManager.showAlertForError(title: String(
                    localized: "source-control.push.failed",
                    defaultValue: "Failed to push",
                    comment: "Error title when push fails"
                ), error: error)
            }
        }
    }
}
