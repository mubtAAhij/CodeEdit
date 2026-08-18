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
                        LabeledContent(String(localized: "source-control.rename-branch.from", defaultValue: "From", comment: "Label for current branch name in rename branch sheet"), value: branch.name)
                        TextField(String(localized: "source-control.rename-branch.to", defaultValue: "To", comment: "Label for target branch name in rename branch sheet"), text: $name)
                    } header: {
                        Text(String(localized: "source-control.rename-branch.title", defaultValue: "Rename branch", comment: "Title for rename branch sheet"))
                        Text(String(localized: "source-control.rename-branch.description", defaultValue: "All uncommited changes will be preserved on the renamed branch.", comment: "Description explaining rename branch behavior"))
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
                        Text(String(localized: "source-control.rename-branch.cancel", defaultValue: "Cancel", comment: "Button title to cancel renaming branch"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source-control.rename-branch.rename", defaultValue: "Rename", comment: "Button title to confirm branch rename"))
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
                    title: String(localized: "source-control.rename-branch.failed-to-create-branch", defaultValue: "Failed to create branch", comment: "Error title shown when branch rename operation fails"),
                    error: error
                )
            }
        }
    }
}
