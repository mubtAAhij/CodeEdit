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
                    Text(String(localized: "source-control.push.title", defaultValue: "Push local changes to", comment: "Push changes title", os_id: "102650"))
                }
                Section {
                    Toggle(String(localized: "source-control.push.force", defaultValue: "Force", comment: "Force push option", os_id: "102651"), isOn: $sourceControlManager.operationForce)
                    Toggle(String(localized: "source-control.push.include-tags", defaultValue: "Include Tags", comment: "Include tags option", os_id: "102652"), isOn: $sourceControlManager.operationIncludeTags)
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
                        Text(String(localized: "source-control.push.in-progress", defaultValue: "Pushing changes...", comment: "Pushing changes progress", os_id: "102653"))
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "source-control.push.cancel", defaultValue: "Cancel", comment: "Cancel button"))
                        .frame(minWidth: 56)
                }
                .disabled(loading)
                Button(action: submit) {
                    Text(String(localized: "source-control.push.button", defaultValue: "Push", comment: "Push button", os_id: "102654"))
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.push.failed", defaultValue: "Failed to push", comment: "Error when push fails", os_id: "102215"), error: error)
            }
        }
    }
}
