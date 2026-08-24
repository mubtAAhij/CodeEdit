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
                        LabeledContent(String(localized: "source-control.rename-branch.from", defaultValue: "From", comment: "Source branch label in rename branch view"), value: branch.name)
                        TextField(String(localized: "source-control.rename-branch.to", defaultValue: "To", comment: "Destination branch label in rename branch view"), text: $name)
                    } header: {
                        Text(String(localized: "source-control.rename-branch.title", defaultValue: "Rename branch", comment: "Title of rename branch confirmation view"))
                        Text(String(localized: "source-control.rename-branch.message", defaultValue: "All uncommited changes will be preserved on the renamed branch.", comment: "Description text explaining rename branch behavior"))
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
                        Text(String(localized: "source-control.rename-branch.cancel", defaultValue: "Cancel", comment: "Cancel button title in rename branch view"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source-control.rename-branch.rename", defaultValue: "Rename", comment: "Confirm button title in rename branch view"))
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
                    title: String(localized: "source-control.rename-branch.failed-to-create-branch", defaultValue: "Failed to create branch", comment: "Error message shown when renaming branch fails"),
                    error: error
                )
            }
        }
    }
}
