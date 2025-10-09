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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status_bar.utility_area.show", comment: "Button tooltip to show the utility area") : String(localized: "status_bar.utility_area.hide", comment: "Button tooltip to hide the utility area"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "status_bar.utility_area.toggle", comment: "Command to toggle utility area"),
                    title: String(localized: "status_bar.utility_area.toggle", comment: "Command to toggle utility area"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status_bar.utility_area.toggle", comment: "Command to toggle utility area"),
                title: String(localized: "status_bar.utility_area.toggle", comment: "Command to toggle utility area"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
