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
                    name: String(localized: "status-bar.toggle-utility-area.action", defaultValue: "Toggle Utility Area", comment: "Accessibility action label to toggle utility area visibility"),
                    title: String(localized: "status-bar.toggle-utility-area.action", defaultValue: "Toggle Utility Area", comment: "Accessibility label for utility area toggle button"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status-bar.toggle-utility-area.action", defaultValue: "Toggle Utility Area", comment: "Menu command title for toggling utility area"),
                title: String(localized: "status-bar.toggle-utility-area.shortcut-hint", defaultValue: "Toggle Utility Area", comment: "Keyboard shortcut help text for toggling utility area"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
