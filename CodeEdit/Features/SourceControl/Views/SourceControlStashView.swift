//
//  SourceControlAddRemoteView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/17/23.
//

import SwiftUI

struct SourceControlStashView: View {
    @EnvironmentObject var sourceControlManager: SourceControlManager
    @Environment(\.dismiss)
    private var dismiss

    @State private var message: String = ""
    @State private var applyStashAfterOperation: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    TextField("", text: $message, prompt: Text(String(localized: "source_control.stash.message_prompt", defaultValue: "Message (optional)", comment: "Stash message prompt")), axis: .vertical)
                        .labelsHidden()
                        .lineLimit(3...3)
                        .contentShape(Rectangle())
                        .frame(height: 48)
                } header: {
                    Text(String(localized: "source_control.stash.title", defaultValue: "Stash Changes", comment: "Stash changes title"))
                    Group {
                        if sourceControlManager.pullSheetIsPresented
                            || sourceControlManager.switchToBranch != nil {
                            Text(String(localized: "source_control.stash.description_required", defaultValue: "Your local repository has uncommitted changes that need to be stashed before you can continue. Enter a description for your changes.", comment: "Stash description when required"))
                        } else {
                            Text(String(localized: "source_control.stash.description_optional", defaultValue: "Enter a description for your stashed changes so you can reference them later. Stashes will appear in the Source Control navigator for your repository.", comment: "Stash description when optional"))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                }
                if sourceControlManager.pullSheetIsPresented
                    || sourceControlManager.switchToBranch != nil {
                    Section {
                        Toggle(String(localized: "source_control.stash.apply_after", defaultValue: "Apply stash after operation", comment: "Apply stash after operation toggle"), isOn: $applyStashAfterOperation)
                    }
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .onSubmit(submit)
            HStack {
                Spacer()
                Button {
                    message = ""
                    dismiss()
                } label: {
                    Text(String(localized: "source_control.stash.cancel", defaultValue: "Cancel", comment: "Cancel button"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                        Text(
                            sourceControlManager.pullSheetIsPresented
                            ? String(localized: "source_control.stash.stash_and_pull", defaultValue: "Stash and Pull", comment: "Stash and pull button")
                            : sourceControlManager.switchToBranch != nil
                            ? String(localized: "source_control.stash.stash_and_switch", defaultValue: "Stash and Switch", comment: "Stash and switch button")
                            : String(localized: "source_control.stash.stash", defaultValue: "Stash", comment: "Stash button")
                        )
                        .frame(minWidth: 56)
                    }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 500)
    }

    func submit() {
        Task {
            do {
                try await sourceControlManager.stashChanges(message: message)
                message = ""

                if sourceControlManager.pullSheetIsPresented
                    || sourceControlManager.switchToBranch != nil {
                    if sourceControlManager.pullSheetIsPresented {
                        try await sourceControlManager.pull(
                            remote: sourceControlManager.operationRemote?.name,
                            branch: sourceControlManager.operationBranch?.name,
                            rebase: sourceControlManager.operationRebase
                        )
                    }

                    if let branch = sourceControlManager.switchToBranch {
                        try await sourceControlManager.checkoutBranch(branch: branch)
                    }

                    if applyStashAfterOperation {
                        guard let lastStashEntry = sourceControlManager.stashEntries.first else {
                            throw NSError(
                                domain: String(localized: "source_control.stash.error_domain", defaultValue: "SourceControl", comment: "Source control error domain"),
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: String(localized: "source_control.stash.error_not_found", defaultValue: "Could not find last stash", comment: "Could not find last stash error")]
                            )
                        }
                        try await sourceControlManager.applyStashEntry(stashEntry: lastStashEntry)
                    }

                    sourceControlManager.operationRemote = nil
                    sourceControlManager.operationBranch = nil
                    sourceControlManager.pullSheetIsPresented = false
                    sourceControlManager.switchToBranch = nil
                }

                dismiss()
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "source_control.stash.error_failed", defaultValue: "Failed to stash changes", comment: "Failed to stash changes error"), error: error)
            }
        }
    }
}
