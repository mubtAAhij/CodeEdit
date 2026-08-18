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
                                localized: "find-navigator.results-summary",
                                defaultValue: "%#@results@ in %#@files@",
                                comment: "Summary text showing number of results and files"
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

                    Text(String(localized: "find-navigator.searching-status", defaultValue: "Searching", comment: "Status message shown while searching in find navigator"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(localized: "find-navigator.replacing-status", defaultValue: "Replacing", comment: "Status message shown while replacing in find navigator"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        String(localized: "find-navigator.no-results-title", defaultValue: "No Results", comment: "Title shown when no find results are available"),
                        description: String(format: String(localized: "find-navigator.no-results-query-message", defaultValue: "No Results for \"%@\" in Project", comment: "Message shown when no results are found for the current query"), "\(state.searchQuery)"),
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    String(localized: "find-navigator.replaced-title", defaultValue: "Replaced", comment: "Title shown after replacement finishes"),
                    description: String(format: String(localized: "find-navigator.replaced-summary", defaultValue: "Successfully replaced terms across %d files", comment: "Summary shown after replacing terms across files"), updatedFiles),
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    String(localized: "find-navigator.error-title", defaultValue: "An Error Occurred", comment: "Title shown when an error occurs in find navigator"),
                    description: String(format: String(localized: "find-navigator.error-message-detail", defaultValue: "%@", comment: "Detailed error message shown in find navigator error state"), "\(errorMessage)"),
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
