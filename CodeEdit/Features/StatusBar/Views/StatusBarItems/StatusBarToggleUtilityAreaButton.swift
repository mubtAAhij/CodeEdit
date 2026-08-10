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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.utility-area.tooltip.show", defaultValue: "Show the Utility area", comment: "Tooltip when utility area is currently hidden and can be shown") : String(localized: "status-bar.utility-area.tooltip.hide", defaultValue: "Hide the Utility area", comment: "Tooltip when utility area is currently visible and can be hidden"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "status-bar.utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Accessibility label for the status bar button that toggles the utility area"),
                    title: String(localized: "status-bar.utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Accessibility hint for toggling the utility area"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status-bar.utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Menu/button title for toggling the utility area"),
                title: String(localized: "status-bar.utility-area.command-title", defaultValue: "Toggle Utility Area", comment: "Command title for toggling utility area in menus"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
