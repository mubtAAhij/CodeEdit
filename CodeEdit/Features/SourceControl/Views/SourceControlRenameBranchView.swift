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
                        LabeledContent(String(localized: "source-control.rename-branch.from-label", defaultValue: "From", comment: "Label for source branch in rename dialog"), value: branch.name)
                        TextField(String(localized: "source-control.rename-branch.to-label", defaultValue: "To", comment: "Label for target branch name in rename dialog"), text: $name)
                    } header: {
                        Text(String(localized: "source-control.rename-branch.title", defaultValue: "Rename branch", comment: "Title for branch rename dialog"))
                        Text(String(localized: "source-control.rename-branch.message", defaultValue: "All uncommited changes will be preserved on the renamed branch.", comment: "Message explaining branch rename behavior"))
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
                        Text(String(localized: "source-control.rename-branch.cancel", defaultValue: "Cancel", comment: "Cancel button in branch rename dialog"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source-control.rename-branch.action", defaultValue: "Rename", comment: "Rename button in branch rename dialog"))
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
                    title: String(localized: "source-control.rename-branch.error", defaultValue: "Failed to create branch", comment: "Error title when branch rename fails"),
                    error: error
                )
            }
        }
    }
}
