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
                    let resultCount = self.searchResultCount
                    let fileCount = self.foundFilesCount
                    Text(String(
                        localized: "find-navigator.results-summary",
                        defaultValue: "\(resultCount) results in \(fileCount) files",
                        comment: "Summary showing number of search results and files"
                    ))
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

                    Text(String(
                        localized: "find-navigator.searching",
                        defaultValue: "Searching",
                        comment: "Status message while searching"
                    ))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(
                        localized: "find-navigator.replacing",
                        defaultValue: "Replacing",
                        comment: "Status message while replacing"
                    ))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    let query = state.searchQuery
                    CEContentUnavailableView(
                        String(
                            localized: "find-navigator.no-results",
                            defaultValue: "No Results",
                            comment: "Title when no search results found"
                        ),
                        description: String(
                            localized: "find-navigator.no-results-description",
                            defaultValue: "No Results for \"\(query)\" in Project",
                            comment: "Description when no search results found for query"
                        ),
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                let filesCount = updatedFiles
                CEContentUnavailableView(
                    String(
                        localized: "find-navigator.replaced",
                        defaultValue: "Replaced",
                        comment: "Title when replacement is complete"
                    ),
                    description: String(
                        localized: "find-navigator.replaced-description",
                        defaultValue: "Successfully replaced terms across \(filesCount) files",
                        comment: "Description showing successful replacement across files"
                    ),
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                let error = errorMessage
                CEContentUnavailableView(
                    String(
                        localized: "find-navigator.error-occurred",
                        defaultValue: "An Error Occurred",
                        comment: "Title when an error occurs"
                    ),
                    description: "\(error)",
                    systemImage: "xmark.octagon.fill"
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
