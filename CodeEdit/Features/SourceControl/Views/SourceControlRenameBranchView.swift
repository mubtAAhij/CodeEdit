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
                        LabeledContent(String(localized: "from", comment: "Label for source branch name"), value: branch.name)
                        TextField(String(localized: "to", comment: "Label for destination branch name"), text: $name)
                    } header: {
                        Text(String(localized: "rename_branch", comment: "Title for rename branch dialog"))
                        Text(String(localized: "all_uncommitted_changes_preserved", comment: "Information about preserving changes when renaming branch"))
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
                        Text(String(localized: "cancel", comment: "Cancel button text"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "rename", comment: "Rename button text"))
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
                    title: String(localized: "failed_to_create_branch", comment: "Error message for branch creation failure"),
                    error: error
                )
            }
        }
    }
}
