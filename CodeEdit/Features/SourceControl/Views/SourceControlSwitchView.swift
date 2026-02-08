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
                    Text(String(format: NSLocalizedString("source-control.switch-branch-prompt", comment: "Switch branch prompt"), branch.name))
                        .font(.headline)
                    Text(String(format: NSLocalizedString("source-control.switch-branch-details", comment: "Switch branch details"), sourceControlManager.currentBranch?.name ?? "", branch.name))
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
                    Text(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button"))
                        .frame(minWidth: 56)
                }
                Button {
                    submit()
                } label: {
                    Text(String(localized: "source-control.switch", defaultValue: "Switch", comment: "Switch button"))
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
                await sourceControlManager.showAlertForError(title: NSLocalizedString("source-control.checkout-failed", comment: "Failed to checkout"), error: error)
            }
        }
    }
}
