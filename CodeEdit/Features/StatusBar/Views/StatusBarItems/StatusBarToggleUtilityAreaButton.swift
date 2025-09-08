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
        .help(utilityAreaViewModel.isCollapsed ? "String(localized: "show_utility_area", comment: "Tooltip text for showing the utility area")" : "String(localized: "hide_utility_area", comment: "Tooltip text for hiding the utility area")")
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: "String(localized: "toggle_utility_area_command_name", comment: "Command name for toggling utility area")",
                    title: "String(localized: "toggle_utility_area_command_title", comment: "Command title for toggling utility area")",
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: "String(localized: "toggle_utility_area_command_name_appear", comment: "Command name for toggling utility area on appear")",
                title: "String(localized: "toggle_utility_area_command_title_appear", comment: "Command title for toggling utility area on appear")",
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
