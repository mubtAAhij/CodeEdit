//
//  SourceControlFetchView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 7/9/24.
//

import SwiftUI

struct SourceControlSwitchView: View {
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject var sourceControlManager: SourceControlManager
    @EnvironmentObject var workspace: WorkspaceDocument

    var branch: GitBranch

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 20) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "sourceControl.switchToBranch", comment: "Dialog title", arguments: branch.name))
                        .font(.headline)
                    Text(
                        String(localized: "sourceControl.switchDescription", comment: "Dialog description", arguments: sourceControlManager.currentBranch?.name ?? "", branch.name)
                    )
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "sourceControl.cancel", comment: "Button text"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                    Text(String(localized: "sourceControl.switch", comment: "Button text"))
                        .frame(minWidth: 56)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 420)
    }

    /// Checks out the specifiied branch and if local changes exist prompts the user to shash changes
    func submit() {
        Task {
            do {
                if !sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.stashSheetIsPresented = true
                } else {
                    try await sourceControlManager.checkoutBranch(branch: branch)
                    dismiss()
                }
            } catch {
                await sourceControlManager.showAlertForError(title: String(localized: "sourceControl.failedToCheckout", comment: "Error message"), error: error)
            }
        }
    }
}
