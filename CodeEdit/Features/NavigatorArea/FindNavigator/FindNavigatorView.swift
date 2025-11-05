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
                    Text(String(localized: "find.results-summary", defaultValue: "\(self.searchResultCount) results in \(self.foundFilesCount) files", comment: "Summary of search results showing count"))
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

                    Text(String(localized: "find.searching", defaultValue: "Searching", comment: "Status message while searching"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .replacing:
                VStack {
                    ProgressView()
                        .padding()

                    Text(String(localized: "find.replacing", defaultValue: "Replacing", comment: "Status message while replacing"))
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                .frame(maxHeight: .infinity)
            case .found:
                if self.searchResultCount == 0 {
                    CEContentUnavailableView(
                        String(localized: "find.no-results", defaultValue: "No Results", comment: "Empty state title when search has no results"),
                        description: String(localized: "find.no-results-description", defaultValue: "No Results for \"\(state.searchQuery)\" in Project", comment: "Empty state description when search has no results"),
                        systemImage: "exclamationmark.magnifyingglass"
                    )
                } else {
                    FindNavigatorResultList()
                }
            case .replaced(let updatedFiles):
                CEContentUnavailableView(
                    String(localized: "find.replaced", defaultValue: "Replaced", comment: "Success state title after replacement"),
                    description: String(localized: "find.replaced-description", defaultValue: "Successfully replaced terms across \(updatedFiles) files", comment: "Success state description after replacement"),
                    systemImage: "checkmark.circle.fill"
                )
            case .failed(let errorMessage):
                CEContentUnavailableView(
                    String(localized: "find.error", defaultValue: "An Error Occurred", comment: "Error state title when search fails"),
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
