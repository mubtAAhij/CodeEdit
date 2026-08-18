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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.toggle-utility-area.show-utility-area", defaultValue: "Show the Utility area", comment: "Tooltip text shown when utility area is hidden and can be shown") : String(localized: "status-bar.toggle-utility-area.hide-utility-area", defaultValue: "Hide the Utility area", comment: "Tooltip text shown when utility area is visible and can be hidden"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "status-bar.toggle-utility-area.command", defaultValue: "Toggle Utility Area", comment: "Command menu item title for toggling utility area visibility"),
                    title: String(localized: "status-bar.toggle-utility-area.command", defaultValue: "Toggle Utility Area", comment: "Button accessibility label for utility area toggle control"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status-bar.toggle-utility-area.command", defaultValue: "Toggle Utility Area", comment: "Toolbar item label for utility area toggle"),
                title: String(localized: "status-bar.toggle-utility-area.hint", defaultValue: "Toggle Utility Area", comment: "Accessibility hint for utility area toggle control"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
