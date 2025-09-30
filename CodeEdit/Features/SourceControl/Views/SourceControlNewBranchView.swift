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
                            String(localized: "source_control.branch.from_label", comment: "Label for source branch"),
                            value: branch.isRemote
                                ? branch.longName.replacingOccurrences(of: "refs/remotes/", with: "")
                                : branch.name
                        )
                        TextField(String(localized: "source_control.branch.to_label", comment: "Label for target branch"), value: $name, formatter: RegexFormatter(pattern: "[^a-zA-Z0-9_-]"))
                    } header: {
                        Text(String(localized: "source_control.branch.create_new_title", comment: "Title for creating a new branch"))
                        Text(
                            "Create a branch from the current branch and switch to it. " +
                            "All uncommited changes will be preserved on the new branch. "
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
                        Text(String(localized: "general.cancel", comment: "Cancel button"))
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text(String(localized: "source_control.branch.create_button", comment: "Button to create a new branch"))
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
                    title: String(localized: "source_control.branch.failed_error", comment: "Error message when branch creation fails"),
                    error: error
                )
            }
        }
    }
}
