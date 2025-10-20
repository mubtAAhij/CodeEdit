//
//  StatusBarToggleUtilityAreaButton.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 22.03.22.
//

import SwiftUI

internal struct StatusBarToggleUtilityAreaButton: View {
    @Environment(\.controlActiveState)
    var controlActiveState

    @EnvironmentObject private var utilityAreaViewModel: UtilityAreaViewModel

    internal var body: some View {
        Button {
            utilityAreaViewModel.togglePanel()
        } label: {
            Image(systemName: "square.bottomthird.inset.filled")
        }
        .buttonStyle(.icon)
        .keyboardShortcut("Y", modifiers: [.command, .shift])
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "statusBar.showUtilityArea", comment: "Tooltip text") : String(localized: "statusBar.hideUtilityArea", comment: "Tooltip text"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "statusBar.toggleUtilityArea", comment: "Command name"),
                    title: String(localized: "statusBar.toggleUtilityArea", comment: "Command title"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "statusBar.toggleUtilityArea", comment: "Command name"),
                title: String(localized: "statusBar.toggleUtilityArea", comment: "Command title"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
