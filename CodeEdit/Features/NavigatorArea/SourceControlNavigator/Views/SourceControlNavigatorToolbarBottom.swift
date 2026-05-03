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
                String(localized: "source_control.filter", defaultValue: "Filter", comment: "Filter text field placeholder"),
                text: $text,
                leadingAccessories: {
                    Image(
                        systemName: text.isEmpty
                        ? String(localized: "source_control.filter.icon.empty", defaultValue: "line.3.horizontal.decrease.circle", comment: "Filter icon when empty")
                        : String(localized: "source_control.filter.icon.filled", defaultValue: "line.3.horizontal.decrease.circle.fill", comment: "Filter icon when filled")
                    )
                    .foregroundStyle(
                        text.isEmpty
                        ? Color(nsColor: .secondaryLabelColor)
                        : Color(nsColor: .controlAccentColor)
                    )
                    .padding(.leading, 4)
                    .help(String(localized: "source_control.filter.help", defaultValue: "Filter Changes Navigator", comment: "Filter changes help text"))
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
            Button(String(localized: "source_control.discard_all", defaultValue: "Discard All Changes...", comment: "Discard all changes button")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToDiscardAlertIsPresented = true
                } else {
                    sourceControlManager.discardAllAlertIsPresented = true
                }
            }
            Button(String(localized: "source_control.stash_changes", defaultValue: "Stash Changes...", comment: "Stash changes button")) {
                if sourceControlManager.changedFiles.isEmpty {
                    sourceControlManager.noChangesToStashAlertIsPresented = true
                } else {
                    sourceControlManager.stashSheetIsPresented = true
                }
            }
        } label: {}
        .background {
            Image(systemName: String(localized: "source_control.menu.icon", defaultValue: "ellipsis.circle", comment: "Source control menu icon"))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(maxWidth: 18, alignment: .center)
    }
}
