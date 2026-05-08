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
                        LabeledContent(String(localized: "git.branch.rename.from", defaultValue: "From", comment: "From branch label"), value: branch.name)
                        TextField(String(localized: "git.branch.rename.to", defaultValue: "To", comment: "To branch field"), text: $name)
                    } header: {
                        Text(String(localized: "git.branch.rename.header", defaultValue: "Rename branch", comment: "Rename branch header"))
                        Text(String(localized: "git.branch.rename.description", defaultValue: "All uncommited changes will be preserved on the renamed branch.", comment: "Rename branch description"))
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
                        Text(String(localized: "git.branch.rename.cancel", defaultValue: "Cancel", comment: "Cancel rename button"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "git.branch.rename.rename", defaultValue: "Rename", comment: "Rename button"))
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
                    title: String(localized: "git.branch.rename.failed", defaultValue: "Failed to create branch", comment: "Failed to create branch error"),
                    error: error
                )
            }
        }
    }
}
