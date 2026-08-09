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
                    Text(
                        String(
                            format: String(
                                localized: "find.navigator.results-summary",
                                defaultValue: "%#@results@ in %#@files@",
                                comment: "Summary of search results and files in find navigator"
                            ),
                            self.searchResultCount,
                            self.foundFilesCount
                        )
                    )
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

                    Text(
                        String(
                            localized: "find.navigator.status.searching",
                            defaultValue: "Searching",
                            comment: "Status text shown while search is in progress"
                        )
                    )
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(
                        String(
                            localized: "find.navigator.status.replacing",
                            defaultValue: "Replacing",
                            comment: "Status text shown while replacement is in progress"
                        )
                    )
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        String(
                            localized: "find_navigator.no_results",
                            defaultValue: "No Results",
                            comment: "Find navigator empty state title when no results are found"
                        ),
                        description: String(
                            format: String(
                                localized: "find_navigator.no_results_for_query",
                                defaultValue: "No Results for \"%@\" in Project",
                                comment: "Find navigator empty state description with query"
                            ),
                            state.searchQuery
                        ),
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    String(
                        localized: "find_navigator.replaced",
                        defaultValue: "Replaced",
                        comment: "Find navigator completion title after replace action"
                    ),
                    description: String(
                        format: String(
                            localized: "find_navigator.replaced_success_message",
                            defaultValue: "Successfully replaced terms across %d files",
                            comment: "Find navigator completion description with updated file count"
                        ),
                        updatedFiles
                    ),
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    String(
                        localized: "find_navigator.error_occurred",
                        defaultValue: "An Error Occurred",
                        comment: "Find navigator error state title"
                    ),
                    description: "\(errorMessage)",
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
