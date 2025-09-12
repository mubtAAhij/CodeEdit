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
                    Text("String(localized: "search_results_summary", comment: "Summary showing number of search results and files").replacingOccurrences(of: "{resultCount}", with: "\(self.searchResultCount)").replacingOccurrences(of: "{fileCount}", with: "\(self.foundFilesCount)")")
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

                    Text("String(localized: "searching", comment: "Status text indicating search is in progress")")
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text("String(localized: "replacing", comment: "Status text indicating replace operation is in progress")")
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        "String(localized: "no_results", comment: "Title shown when no search results are found")",
                        description: "String(localized: "no_results_for_query", comment: "Description shown when no search results are found for a specific query").replacingOccurrences(of: "{query}", with: "\"\(state.searchQuery)\"")",
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    "String(localized: "replaced", comment: "Title shown when replace operation is completed")",
                    description: "String(localized: "replace_success_message", comment: "Success message showing number of files where terms were replaced").replacingOccurrences(of: "{fileCount}", with: "\(updatedFiles)")",
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    "String(localized: "error_occurred", comment: "Title shown when an error occurs during search or replace operation")",
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
