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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.utility-area.show", defaultValue: "Show the Utility area", comment: "Help text to show utility area") : String(localized: "status-bar.utility-area.hide", defaultValue: "Hide the Utility area", comment: "Help text to hide utility area"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "status-bar.utility-area.toggle", defaultValue: "Toggle Utility Area", comment: "Command name to toggle utility area"),
                    title: String(localized: "status-bar.utility-area.toggle.title", defaultValue: "Toggle Utility Area", comment: "Command title to toggle utility area"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "status-bar.utility-area.toggle.name", defaultValue: "Toggle Utility Area", comment: "Command name for toggle utility area on appear"),
                title: String(localized: "status-bar.utility-area.toggle.appear-title", defaultValue: "Toggle Utility Area", comment: "Command title for toggle utility area on appear"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
