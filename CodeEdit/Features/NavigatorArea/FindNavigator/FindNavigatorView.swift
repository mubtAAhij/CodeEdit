//
//  FindNavigatorView.swift
//  CodeEdit
//
//  Created by Ziyuan Zhao on 2022/3/20.
//

import SwiftUI

struct FindNavigatorView: View {
    @EnvironmentObject private var workspace: WorkspaceDocument

    private var state: WorkspaceDocument.SearchState {
        workspace.searchState ?? .init(workspace)
    }

    @State private var foundFilesCount: Int = 0
    @State private var searchResultCount: Int = 0
    @State private var findNavigatorStatus: WorkspaceDocument.SearchState.FindNavigatorStatus = .none
    @State private var findResultMessage: String?

    var body: some View {
        VStack {
            VStack {
                FindNavigatorForm(state: state)
                FindNavigatorIndexBar(state: state)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)

            Divider()

            if findNavigatorStatus == .found {
                HStack(alignment: .center) {
                    Text(String(format: String(localized: "find.results.summary", defaultValue: "%d results in %d files", comment: "Find results summary showing result count and file count"), self.searchResultCount, self.foundFilesCount))
                        .font(.system(size: 10))
                }

                Divider()
            }

            switch self.findNavigatorStatus {
            case .none:
                Spacer()
            case .searching:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(localized: "find.searching.status", defaultValue: "Searching", comment: "Find navigator searching status"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(localized: "find.replacing.status", defaultValue: "Replacing", comment: "Find navigator replacing status"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        String(localized: "find.no.results.title", defaultValue: "No Results", comment: "Find no results title"),
                        description: String(format: String(localized: "find.no.results.description", defaultValue: "No Results for \"%@\" in Project", comment: "Find no results description with search query"), state.searchQuery),
                        systemImage: String(localized: "find.no.results.icon", defaultValue: "exclamationmark.magnifyingglass", comment: "Find no results icon")
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    String(localized: "find.replaced.title", defaultValue: "Replaced", comment: "Find replaced title"),
                    description: String(format: String(localized: "find.replaced.description", defaultValue: "Successfully replaced terms across %d files", comment: "Find replaced description with file count"), updatedFiles),
                    systemImage: String(localized: "find.replaced.icon", defaultValue: "checkmark.circle.fill", comment: "Find replaced icon")
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    String(localized: "find.error.title", defaultValue: "An Error Occurred", comment: "Find error title"),
                    description: String(format: String(localized: "find.error.description", defaultValue: "%@", comment: "Find error description with error message"), errorMessage),
                    systemImage: String(localized: "find.error.icon", defaultValue: "xmark.octagon.fill", comment: "Find error icon")
                )
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            FindNavigatorToolbarBottom()
        }
        .onReceive(state.$searchResult, perform: { value in
            self.foundFilesCount = value.count
        })
        .onReceive(state.$searchResultsCount, perform: { value in
            self.searchResultCount = value
        })
        .onReceive(state.$findNavigatorStatus, perform: { value in
            self.findNavigatorStatus = value
        })
    }
}
