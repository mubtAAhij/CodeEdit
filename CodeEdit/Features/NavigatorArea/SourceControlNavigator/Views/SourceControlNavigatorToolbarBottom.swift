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
                String(localized: "sourcecontrol.navigator.filter", defaultValue: "Filter", comment: "Filter text field placeholder"),
                text: $text,
                leadingAccessories: {
                    Image(
                        systemName: text.isEmpty
                        ? String(localized: "sourcecontrol.navigator.filter.icon.empty", defaultValue: "line.3.horizontal.decrease.circle", comment: "SF Symbol for filter icon when empty")
                        : String(localized: "sourcecontrol.navigator.filter.icon.filled", defaultValue: "line.3.horizontal.decrease.circle.fill", comment: "SF Symbol for filter icon when filled")
                    )
                    .foregroundStyle(
                        text.isEmpty
                        ? Color(nsColor: .secondaryLabelColor)
                        : Color(nsColor: .controlAccentColor)
                    )
                    .padding(.leading, 4)
                    .help(String(localized: "sourcecontrol.navigator.filter.help", defaultValue: "Filter Changes Navigator", comment: "Filter changes navigator tooltip"))
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
            Button(String(localized: "sourcecontrol.navigator.discard.all", defaultValue: "Discard All Changes...", comment: "Discard all changes menu item")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToDiscardAlertIsPresented = true
                } else {
                    sourceControlManager.discardAllAlertIsPresented = true
                }
            }
            Button(String(localized: "sourcecontrol.navigator.stash.changes", defaultValue: "Stash Changes...", comment: "Stash changes menu item")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToStashAlertIsPresented = true
                } else {
                    sourceControlManager.stashSheetIsPresented = true
                }
            }
        } label: {}
        .background {
            Image(systemName: String(localized: "sourcecontrol.navigator.menu.icon", defaultValue: "ellipsis.circle", comment: "SF Symbol for source control menu icon"))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(maxWidth: 18, alignment: .center)
    }
}
