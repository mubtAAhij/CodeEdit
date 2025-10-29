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
                            String(localized: "From", comment: "Label for source branch selection"),
                            value: branch.isRemote
                                ? branch.longName.replacingOccurrences(of: "refs/remotes/", with: "")
                                : branch.name
                        )
                        TextField(String(localized: "To", comment: "Label for new branch name input"), value: $name, formatter: RegexFormatter(pattern: "[^a-zA-Z0-9_-]"))
                    } header: {
                        Text(String(localized: "Create a new branch", comment: "Header for new branch creation section"))
                        Text(String(localized: "Create a branch from the current branch and switch to it. All uncommited changes will be preserved on the new branch. ", comment: "Description of new branch creation behavior"))
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
                        Text(String(localized: "Cancel", comment: "Button to cancel branch creation"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "Create", comment: "Button to create new branch"))
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
                    title: String(localized: "Failed to create branch", comment: "Error message when branch creation fails"),
                    error: error
                )
            }
        }
    }
}
