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
                    TextField("", text: $message, prompt: Text(String(localized: "source-control.stash.message-optional", defaultValue: "Message (optional)", comment: "Placeholder for optional stash message input")), axis: .vertical)
                        .labelsHidden()
                        .lineLimit(3...3)
                        .contentShape(Rectangle())
                        .frame(height: 48)
                } header: {
                    Text(String(localized: "source-control.stash.title", defaultValue: "Stash Changes", comment: "Title for stash changes sheet"))
                    Group {
                        if sourceControlManager.pullSheetIsPresented
                            || sourceControlManager.switchToBranch != nil {
                            Text(String(localized: "source-control.stash.precondition-description", defaultValue: "Your local repository has uncommitted changes that need to be stashed before you can continue. Enter a description for your changes.", comment: "Description explaining why stashing is required before continuing"))
                        } else {
                            Text(String(localized: "source-control.stash.message-description", defaultValue: "Enter a description for your stashed changes so you can reference them later. Stashes will appear in the Source Control navigator for your repository.", comment: "Helper text for stash message input and where stashes appear"))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                }
                if sourceControlManager.pullSheetIsPresented
                    || sourceControlManager.switchToBranch != nil {
                    Section {
                        Toggle(String(localized: "source-control.stash.apply-after-operation", defaultValue: "Apply stash after operation", comment: "Toggle label to apply stashed changes after the operation"), isOn: $applyStashAfterOperation)
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
                    Text(String(localized: "source-control.stash.cancel", defaultValue: "Cancel", comment: "Cancel button in stash changes sheet"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                        Text(
                            sourceControlManager.pullSheetIsPresented
                            ? String(localized: "source-control.stash.action.stash-and-pull", defaultValue: "Stash and Pull", comment: "Primary action to stash changes and then pull")
                            : sourceControlManager.switchToBranch != nil
                            ? String(localized: "source-control.stash.action.stash-and-switch", defaultValue: "Stash and Switch", comment: "Primary action to stash changes and then switch branches")
                            : String(localized: "source-control.stash.action.stash", defaultValue: "Stash", comment: "Primary action to stash changes")
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
                                domain: "SourceControl",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: String(localized: "source-control.stash.error.last-stash-not-found", defaultValue: "Could not find last stash", comment: "Error shown when last stash cannot be found")]
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
                await sourceControlManager.showAlertForError(title: String(localized: "source-control.stash.error.failed-to-stash", defaultValue: "Failed to stash changes", comment: "Error shown when stashing changes fails"), error: error)
            }
        }
    }
}
