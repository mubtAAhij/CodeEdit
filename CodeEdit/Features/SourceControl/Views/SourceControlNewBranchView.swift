//
//  SourceControlNewBranchView.swift
//  CodeEdit
//
//  Created by Albert Vinizhanau on 10/21/23.
//

import SwiftUI

struct SourceControlNewBranchView: View {
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
                        LabeledContent(
                            String(localized: "source-control.new-branch.from-label", defaultValue: "From", comment: "Label for source branch field"),
                            value: branch.isRemote
                                ? branch.longName.replacingOccurrences(of: "refs/remotes/", with: "")
                                : branch.name
                        )
                        TextField(String(localized: "source-control.new-branch.to-label", defaultValue: "To", comment: "Label for new branch name field"), value: $name, formatter: RegexFormatter(pattern: "[^a-zA-Z0-9_-]"))
                    } header: {
                        Text(String(localized: "source-control.new-branch.title", defaultValue: "Create a new branch", comment: "Title for create new branch form"))
                        Text(
                            String(localized: "source-control.new-branch.description", defaultValue: "Create a branch from the current branch and switch to it. All uncommited changes will be preserved on the new branch. ", comment: "Description of new branch creation behavior")
                        )
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
                        Text(String(localized: "source-control.new-branch.cancel-button", defaultValue: "Cancel", comment: "Cancel button for new branch dialog"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source-control.new-branch.create-button", defaultValue: "Create", comment: "Create button for new branch dialog"))
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

    /// Creates a new branch from the specifiied source branch
    func submit(_ branch: GitBranch) {
        Task {
            do {
                try await sourceControlManager.newBranch(name: name, from: branch)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await sourceControlManager.showAlertForError(
                    title: String(localized: "source-control.new-branch.error-title", defaultValue: "Failed to create branch", comment: "Error message title when branch creation fails"),
                    error: error
                )
            }
        }
    }
}
