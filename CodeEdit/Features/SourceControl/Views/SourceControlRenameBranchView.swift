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
                        LabeledContent(String(localized: "git.rename_branch.from", defaultValue: "From", comment: "From label"), value: branch.name)
                        TextField(String(localized: "git.rename_branch.to", defaultValue: "To", comment: "To label"), text: $name)
                    } header: {
                        Text(String(localized: "git.rename_branch.header", defaultValue: "Rename branch", comment: "Rename branch header"))
                        Text(String(localized: "git.rename_branch.info", defaultValue: "All uncommited changes will be preserved on the renamed branch.", comment: "Rename branch info"))
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
                        Text(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "git.rename_branch.button", defaultValue: "Rename", comment: "Rename button"))
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
                    title: String(localized: "git.rename_branch.failed", defaultValue: "Failed to create branch", comment: "Failed to rename branch error"),
                    error: error
                )
            }
        }
    }
}
