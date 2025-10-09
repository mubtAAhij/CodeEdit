//
//  SourceControlRenameBranchView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 11/28/23.
//

import SwiftUI

struct SourceControlRenameBranchView: View {
    @Environment(\.dismiss)
    var dismiss

    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State var name: String = ""

    @Binding var fromBranch: GitBranch?

    var body: some View {
        if let branch = fromBranch ?? sourceControlManager.currentBranch {
            VStack(spacing: 0) {
                Form {
                    Section {
                        LabeledContent(String(localized: "source_control.rename_branch.from_label", comment: "Label for the current branch name in rename branch dialog"), value: branch.name)
                        TextField(String(localized: "source_control.rename_branch.to_placeholder", comment: "Placeholder text for new branch name field"), text: $name)
                    } header: {
                        Text(String(localized: "source_control.rename_branch.title", comment: "Title for rename branch dialog"))
                        Text(String(localized: "source_control.rename_branch.description", comment: "Description explaining that changes will be preserved when renaming branch"))
                    }
                }
                .formStyle(.grouped)
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .onSubmit { submit(branch) }
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text(String(localized: "common.cancel", comment: "Cancel button text"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source_control.rename_branch.rename_button", comment: "Rename button text in rename branch dialog"))
                            .frame(minWidth: 56)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
            .frame(width: 500)
        }
    }

    func submit(_ branch: GitBranch) {
        Task {
            do {
                try await sourceControlManager.renameBranch(oldName: branch.name, newName: name)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await sourceControlManager.showAlertForError(
                    title: String(localized: "source_control.error.failed_to_create_branch", comment: "Error message when branch creation fails"),
                    error: error
                )
            }
        }
    }
}
