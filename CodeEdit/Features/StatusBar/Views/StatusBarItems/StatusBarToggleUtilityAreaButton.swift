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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "utility-area.show", defaultValue: "Show the Utility area", comment: "Tooltip to show the utility area") : String(localized: "utility-area.hide", defaultValue: "Hide the Utility area", comment: "Tooltip to hide the utility area"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Command to toggle utility area"),
                    title: String(localized: "utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Command to toggle utility area"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Command to toggle utility area"),
                title: String(localized: "utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Command to toggle utility area"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
