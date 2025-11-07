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
                    TextField("", text: $message, prompt: Text(String(
                        localized: "source-control-stash.message-placeholder",
                        defaultValue: "Message (optional)",
                        comment: "Placeholder for stash message field"
                    )), axis: .vertical)
                        .labelsHidden()
                        .lineLimit(3...3)
                        .contentShape(Rectangle())
                        .frame(height: 48)
                } header: {
                    Text(String(
                        localized: "source-control-stash.title",
                        defaultValue: "Stash Changes",
                        comment: "Section header for stash changes"
                    ))
                    Group {
                        if sourceControlManager.pullSheetIsPresented
                            || sourceControlManager.switchToBranch != nil {
                            Text(String(
                                localized: "source-control-stash.description-before-operation",
                                defaultValue: "Your local repository has uncommitted changes that need to be stashed before you can continue. Enter a description for your changes.",
                                comment: "Description when stashing before pull or switch"
                            ))
                        } else {
                            Text(String(
                                localized: "source-control-stash.description-manual",
                                defaultValue: "Enter a description for your stashed changes so you can reference them later. Stashes will appear in the Source Control navigator for your repository.",
                                comment: "Description when manually stashing changes"
                            ))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                }
                if sourceControlManager.pullSheetIsPresented
                    || sourceControlManager.switchToBranch != nil {
                    Section {
                        Toggle(String(
                            localized: "source-control-stash.apply-after-operation",
                            defaultValue: "Apply stash after operation",
                            comment: "Toggle to apply stash after operation"
                        ), isOn: $applyStashAfterOperation)
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
                    Text(String(
                        localized: "source-control-stash.cancel",
                        defaultValue: "Cancel",
                        comment: "Button to cancel stash operation"
                    ))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                        Text(
                            sourceControlManager.pullSheetIsPresented
                            ? String(
                                localized: "source-control-stash.stash-and-pull",
                                defaultValue: "Stash and Pull",
                                comment: "Button to stash changes and pull"
                            )
                            : sourceControlManager.switchToBranch != nil
                            ? String(
                                localized: "source-control-stash.stash-and-switch",
                                defaultValue: "Stash and Switch",
                                comment: "Button to stash changes and switch branch"
                            )
                            : String(
                                localized: "source-control-stash.stash",
                                defaultValue: "Stash",
                                comment: "Button to stash changes"
                            )
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
                                userInfo: [NSLocalizedDescriptionKey: String(
                                    localized: "source-control-stash.error-no-stash-found",
                                    defaultValue: "Could not find last stash",
                                    comment: "Error message when last stash cannot be found"
                                )]
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
                await sourceControlManager.showAlertForError(
                    title: String(
                        localized: "source-control-stash.error-failed-to-stash",
                        defaultValue: "Failed to stash changes",
                        comment: "Error title when stashing fails"
                    ),
                    error: error
                )
            }
        }
    }
}
