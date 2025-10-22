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
            HStack {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 50)
                VStack(alignment: .leading) {
                    Text("source_control.clone.title", comment: "View title")
                        .bold()
                        .padding(.bottom, 2)
                    Text("source_control.clone.enter_url", comment: "Text label")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .alignmentGuide(.trailing) { context in
                            context[.trailing]
                        }
                    TextField(String(localized: "source_control.clone.url_placeholder", defaultValue: "Git Repository URL", comment: "Text field label"), text: $viewModel.repoUrlStr)
                        .lineLimit(1)
                        .padding(.bottom, 15)
                        .frame(width: 300)

                    HStack {
                        Button(String(localized: "source_control.clone.cancel", defaultValue: "Cancel", comment: "Button text")) {
                            dismiss()
                        }
                        Button(String(localized: "source_control.clone.clone_button", defaultValue: "Clone", comment: "Button text")) {
                            cloneRepository()
                        }
                        .keyboardShortcut(.defaultAction)
                        .disabled(!viewModel.isValidUrl(url: viewModel.repoUrlStr))
                    }
                    .offset(x: 185)
                    .alignmentGuide(.leading) { context in
                        context[.leading]
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .onAppear {
                viewModel.checkClipboard()
            }
            .sheet(isPresented: $viewModel.isCloning) {
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
                        Button(String(localized: "source_control.clone.cancel_cloning", defaultValue: "Cancel Cloning", comment: "Button text")) {
                            viewModel.cloningTask?.cancel()
                            viewModel.cloningTask = nil
                            viewModel.isCloning = false
                        }
                    }
                }
                .padding()
                .frame(width: 350)
            }
        }
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
