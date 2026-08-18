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
                String(localized: "source-control.navigator.toolbar.filter", defaultValue: "Filter", comment: "Toolbar filter field label in source control navigator"),
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
                    .help(String(localized: "source-control.navigator.toolbar.filter-changes-navigator", defaultValue: "Filter Changes Navigator", comment: "Accessibility label for source control navigator filter field"))
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
            Button(String(localized: "source-control.navigator.toolbar.discard-all-changes", defaultValue: "Discard All Changes...", comment: "Menu item title to discard all working changes")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToDiscardAlertIsPresented = true
                } else {
                    sourceControlManager.discardAllAlertIsPresented = true
                }
            }
            Button(String(localized: "source-control.navigator.toolbar.stash-changes", defaultValue: "Stash Changes...", comment: "Menu item title to stash current changes")) {
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
