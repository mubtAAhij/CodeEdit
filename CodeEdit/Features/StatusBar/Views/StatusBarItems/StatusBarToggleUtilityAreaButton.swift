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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.toggle-utility-area.show-utility-area", defaultValue: "Show the Utility area", comment: "Tooltip when utility area is hidden and can be shown") : String(localized: "status-bar.toggle-utility-area.hide-utility-area", defaultValue: "Hide the Utility area", comment: "Tooltip when utility area is visible and can be hidden"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "status-bar.toggle-utility-area.action-primary", defaultValue: "Toggle Utility Area", comment: "Accessibility/action label for toggling utility area visibility"),
                    title: String(localized: "status-bar.toggle-utility-area.action-secondary", defaultValue: "Toggle Utility Area", comment: "Menu or command label for toggling utility area visibility"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status-bar.toggle-utility-area.action-tertiary", defaultValue: "Toggle Utility Area", comment: "Alternate command label for toggling utility area visibility"),
                title: String(localized: "status-bar.toggle-utility-area.button-title", defaultValue: "Toggle Utility Area", comment: "Button title for utility area visibility toggle"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
