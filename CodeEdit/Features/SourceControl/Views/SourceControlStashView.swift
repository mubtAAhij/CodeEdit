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
                    TextField("", text: $message, prompt: Text(String(localized: "message_optional", comment: "Placeholder text for optional message field")), axis: .vertical)
                        .labelsHidden()
                        .lineLimit(3...3)
                        .contentShape(Rectangle())
                        .frame(height: 48)
                } header: {
                    Text(String(localized: "stash_changes", comment: "Title for stash changes dialog"))
                    Group {
                        if sourceControlManager.pullSheetIsPresented
                            || sourceControlManager.switchToBranch != nil {
                            Text(String(localized: "repository_has_uncommitted_changes", comment: "Message about uncommitted changes needing to be stashed") +
                                 String(localized: "enter_description_for_changes", comment: "Instruction to enter description for changes"))
                        } else {
                            Text(String(localized: "enter_description_for_stashed_changes", comment: "Instruction to enter description for stashed changes") +
                                 String(localized: "stashes_appear_in_navigator", comment: "Information about where stashes appear"))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                }
                if sourceControlManager.pullSheetIsPresented
                    || sourceControlManager.switchToBranch != nil {
                    Section {
                        Toggle(String(localized: "apply_stash_after_operation", comment: "Toggle option to apply stash after operation"), isOn: $applyStashAfterOperation)
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
                    Text(String(localized: "cancel", comment: "Cancel button text"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                        Text(
                            sourceControlManager.pullSheetIsPresented
                            ? String(localized: "stash_and_pull", comment: "Button text for stashing and pulling")
                            : sourceControlManager.switchToBranch != nil
                            ? String(localized: "stash_and_switch", comment: "Button text for stashing and switching")
                            : String(localized: "stash", comment: "Button text for stashing")
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
                                userInfo: [NSLocalizedDescriptionKey: String(localized: "could_not_find_last_stash", comment: "Error message when last stash cannot be found")]
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
                await sourceControlManager.showAlertForError(title: String(localized: "failed_to_stash_changes", comment: "Error message for stash failure"), error: error)
            }
        }
    }
}
