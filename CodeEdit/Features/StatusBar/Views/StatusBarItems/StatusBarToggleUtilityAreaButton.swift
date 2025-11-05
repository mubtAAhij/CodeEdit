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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.show-utility-area", defaultValue: "Show the Utility area", comment: "Tooltip for showing utility area") : String(localized: "status-bar.hide-utility-area", defaultValue: "Hide the Utility area", comment: "Tooltip for hiding utility area"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "command.toggle-utility-area.name", defaultValue: "Toggle Utility Area", comment: "Command name for toggling utility area"),
                    title: String(localized: "command.toggle-utility-area.title", defaultValue: "Toggle Utility Area", comment: "Command title for toggling utility area"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "command.toggle-utility-area.name", defaultValue: "Toggle Utility Area", comment: "Command name for toggling utility area"),
                title: String(localized: "command.toggle-utility-area.title", defaultValue: "Toggle Utility Area", comment: "Command title for toggling utility area"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
