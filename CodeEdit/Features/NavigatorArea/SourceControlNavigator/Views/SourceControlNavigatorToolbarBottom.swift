//
//  SourceControlNavigatorToolbarBottom.swift
//  CodeEdit
//
//  Created by Nanashi Li on 2022/05/20.
//

import SwiftUI

struct SourceControlNavigatorToolbarBottom: View {
    @EnvironmentObject private var workspace: WorkspaceDocument
    @EnvironmentObject var sourceControlManager: SourceControlManager

    @State private var text = ""

    var body: some View {
        HStack(spacing: 5) {
            sourceControlMenu
            PaneTextField(
                String(localized: "navigator.source-control.toolbar.filter", defaultValue: "Filter", comment: "Toolbar button title to filter source control navigator items"),
                text: $text,
                leadingAccessories: {
                    Image(
                        systemName: text.isEmpty
                        ? "line.3.horizontal.decrease.circle"
                        : "line.3.horizontal.decrease.circle.fill"
                    )
                    .foregroundStyle(
                        text.isEmpty
                        ? Color(nsColor: .secondaryLabelColor)
                        : Color(nsColor: .controlAccentColor)
                    )
                    .padding(.leading, 4)
                    .help(String(localized: "navigator.source-control.toolbar.filter-changes-navigator", defaultValue: "Filter Changes Navigator", comment: "Accessibility label for filter control in changes navigator"))
                },
                clearable: true
            )
        }
        .frame(height: 28, alignment: .center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
        .overlay(alignment: .top) {
            Divider()
                .opacity(0)
        }
    }

    private var sourceControlMenu: some View {
        Menu {
            Button(String(localized: "navigator.source-control.toolbar.discard-all-changes", defaultValue: "Discard All Changes...", comment: "Menu action title to discard all source control changes")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToDiscardAlertIsPresented = true
                } else {
                    sourceControlManager.discardAllAlertIsPresented = true
                }
            }
            Button(String(localized: "navigator.source-control.toolbar.stash-changes", defaultValue: "Stash Changes...", comment: "Menu action title to stash source control changes")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToStashAlertIsPresented = true
                } else {
                    sourceControlManager.stashSheetIsPresented = true
                }
            }
        } label: {}
        .background {
            Image(systemName: "ellipsis.circle")
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(maxWidth: 18, alignment: .center)
    }
}
