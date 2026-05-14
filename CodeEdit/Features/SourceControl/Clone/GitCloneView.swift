//
//  GitCloneView.swift
//  CodeEditModules/Git
//
//  Created by Aleksi Puttonen on 23.3.2022.
//

import SwiftUI
import Foundation
import Combine

struct GitCloneView: View {
    @Environment(\.dismiss)
    private var dismiss

    @StateObject private var viewModel: GitCloneViewModel = .init()

    private let openBranchView: (URL) -> Void
    private let openDocument: (URL) -> Void

    init(
        openBranchView: @escaping (URL) -> Void,
        openDocument: @escaping (URL) -> Void
    ) {
        self.openBranchView = openBranchView
        self.openDocument = openDocument
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading) {
                    Text(String(localized: "source-control.clone.title", defaultValue: "Clone a Repository", comment: "Title for git clone view"))
                        .bold()
                        .padding(.bottom, 2)
                    Text(String(localized: "source-control.clone.prompt", defaultValue: "Enter a git repository URL:", comment: "Prompt for git repository URL input"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .alignmentGuide(.trailing) { context in
                            context[.trailing]
                        }
                    TextField(String(localized: "source-control.clone.url-field", defaultValue: "Git Repository URL", comment: "Placeholder for git repository URL text field"), text: $viewModel.repoUrlStr)
                        .lineLimit(1)
                        .padding(.bottom, 15)

                    HStack {
                        Spacer()
                        Button(String(localized: "source-control.clone.cancel", defaultValue: "Cancel", comment: "Cancel button for git clone")) {
                            dismiss()
                        }
                        Button(String(localized: "source-control.clone.clone-button", defaultValue: "Clone", comment: "Clone button to start cloning repository")) {
                            cloneRepository()
                        }
                        .keyboardShortcut(.defaultAction)
                        .disabled(!viewModel.isValidUrl(url: viewModel.repoUrlStr))
                    }
                }
                .frame(width: 300)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .onAppear {
                viewModel.checkClipboard()
            }
            .sheet(isPresented: $viewModel.isCloning) {
                cloningSheet
            }
        }
    }

    @ViewBuilder private var cloningSheet: some View {
        NavigationStack {
            VStack {
                ProgressView(
                    viewModel.cloningProgress.state.label,
                    value: viewModel.cloningProgress.progress,
                    total: 100
                )
            }
        }
        .toolbar {
            ToolbarItem {
                Button(String(localized: "source-control.clone.cancel-cloning", defaultValue: "Cancel Cloning", comment: "Button to cancel ongoing clone operation")) {
                    viewModel.cloningTask?.cancel()
                    viewModel.cloningTask = nil
                    viewModel.isCloning = false
                }
            }
        }
        .padding()
        .frame(width: 350)
    }

    func cloneRepository() {
        viewModel.cloneRepository { localPath in
            dismiss()

            guard let gitClient = viewModel.gitClient else { return }

            Task {
                let branches = ((try? await  gitClient.getBranches()) ?? [])
                    .filter({ $0.isRemote })
                if branches.count > 1 {
                    openBranchView(localPath)
                    return
                }

                openDocument(localPath)
            }
        }
    }
}
