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
                    Text(String(localized: "search_results_summary", comment: "Summary of search results count").replacingOccurrences(of: "{resultCount}", with: "\(self.searchResultCount)").replacingOccurrences(of: "{fileCount}", with: "\(self.foundFilesCount)"))
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

                    Text(String(localized: "searching", comment: "Text shown during search operation"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(localized: "replacing", comment: "Text shown during replace operation"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        String(localized: "no_results", comment: "Title when no search results found"),
                        description: String(localized: "no_results_for_query", comment: "Description when no results found for search query").replacingOccurrences(of: "{query}", with: "\(state.searchQuery)"),
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    String(localized: "replaced", comment: "Title when replacement operation completed"),
                    description: String(localized: "successfully_replaced_terms", comment: "Success message for replacement operation").replacingOccurrences(of: "{fileCount}", with: "\(updatedFiles)"),
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    String(localized: "error_occurred", comment: "Title when an error occurs"),
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
