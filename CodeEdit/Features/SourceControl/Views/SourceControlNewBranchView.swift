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
                            "source_control.new_branch.from",
                            comment: "Label for source branch",
                            value: branch.isRemote
                                ? branch.longName.replacingOccurrences(of: "refs/remotes/", with: "")
                                : branch.name
                        )
                        TextField("source_control.new_branch.to", text: $name, prompt: Text("source_control.new_branch.to", comment: "Placeholder for new branch name"))
                            .onChange(of: name) { _, newValue in
                                name = newValue.replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "", options: .regularExpression)
                            }
                    } header: {
                        Text("source_control.new_branch.header", comment: "Section header")
                        Text(
                            "source_control.new_branch.description",
                            comment: "Description for creating a new branch"
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
                        Text("actions.cancel", comment: "Cancel button")
                            .frame(minWidth: 56)
                    }
                    Button {
                        submit(branch)
                    } label: {
                        Text("source_control.new_branch.create", comment: "Create branch button")
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
                    title: String(localized: "source_control.new_branch.error", comment: "Error message"),
                    error: error
                )
            }
        }
    }
}
