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
                    Text(String(localized: "source-control.push.label", defaultValue: "Push local changes to", comment: "Header for push operation section"))
                }
                Section {
                    Toggle(String(localized: "source-control.push.force-option", defaultValue: "Force", comment: "Toggle for force push option"), isOn: $sourceControlManager.operationForce)
                    Toggle(String(localized: "source-control.push.include-tags-option", defaultValue: "Include Tags", comment: "Toggle for including tags in push"), isOn: $sourceControlManager.operationIncludeTags)
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
                        Text(String(localized: "source-control.push.progress", defaultValue: "Pushing changes...", comment: "Progress message while pushing"))
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "source-control.push.cancel", defaultValue: "Cancel", comment: "Cancel push operation button"))
                        .frame(minWidth: 56)
                }
                .disabled(loading)
                Button(action: submit) {
                    Text(String(localized: "source-control.push.action", defaultValue: "Push", comment: "Button to execute push operation"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source_control.push.error", defaultValue: "Failed to push", comment: "Error message when push fails"), error: error)
            }
        }
    }
}
