//
//  GitCheckoutBranchView.swift
//  CodeEditModules/Git
//
//  Created by Aleksi Puttonen on 14.4.2022.
//

import Foundation
import SwiftUI

struct GitCheckoutBranchView: View {
    @Environment(\.dismiss)
    private var dismiss

    @StateObject private var viewModel: GitCheckoutBranchViewModel
    private var openDocument: (URL) -> Void

    init(
        repoLocalPath: URL,
        openDocument: @escaping (URL) -> Void
    ) {
        _viewModel = .init(wrappedValue: GitCheckoutBranchViewModel(repoPath: repoLocalPath))
        self.openDocument = openDocument
    }
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 50)
                VStack(alignment: .leading) {
                    Text(String(localized: "git.checkout.title", defaultValue: "Checkout branch", comment: "Git checkout branch dialog title"))
                        .bold()
                        .padding(.bottom, 2)
                    Text(String(localized: "git.checkout.instruction", defaultValue: "Select a branch to checkout", comment: "Instruction to select a branch"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .alignmentGuide(.trailing) { context in
                        context[.trailing]
                    }
                    Picker("", selection: $viewModel.selectedBranch, content: {
                        ForEach(viewModel.branches, id: \.self) { branch in
                            Text(branch.name.replacingOccurrences(of: String(localized: "git.branch.origin_prefix", defaultValue: "origin/", comment: "Git origin branch prefix"), with: ""))
                                .tag(branch as GitBranch?)
                        }
                    })
                    .labelsHidden()

                    HStack {
                        Button(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                            dismiss()
                        }
                        Button(String(localized: "git.checkout.button", defaultValue: "Checkout", comment: "Checkout button")) {
                            Task {
                                await viewModel.checkoutBranch()
                                await MainActor.run {
                                    dismiss()
                                    openDocument(viewModel.repoPath)
                                }
                            }
                        }
                        .keyboardShortcut(.defaultAction)
                    }
                    .alignmentGuide(.trailing) { context in
                        context[.trailing]
                    }
                    .offset(x: 145)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .frame(width: 400)
            .task {
                await viewModel.loadBranches()
            }
        }
    }
}
