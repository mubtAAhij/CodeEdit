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
                    Text(String(localized: "git.clone.title", defaultValue: "Clone a Repository", comment: "Clone repository title"))
                        .bold()
                        .padding(.bottom, 2)
                    Text(String(localized: "git.clone.prompt", defaultValue: "Enter a git repository URL:", comment: "Enter git URL prompt"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .alignmentGuide(.trailing) { context in
                            context[.trailing]
                        }
                    TextField(String(localized: "git.clone.url-field", defaultValue: "Git Repository URL", comment: "Git repository URL field"), text: $viewModel.repoUrlStr)
                        .lineLimit(1)
                        .padding(.bottom, 15)

                    HStack {
                        Spacer()
                        Button(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button")) {
                            dismiss()
                        }
                        Button(String(localized: "git.clone.button", defaultValue: "Clone", comment: "Clone button")) {
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
                Button(String(localized: "git.clone.cancel-cloning", defaultValue: "Cancel Cloning", comment: "Cancel cloning button")) {
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
