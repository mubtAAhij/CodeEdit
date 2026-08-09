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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "status-bar.toggle-utility-area.show", defaultValue: "Show the Utility area", comment: "Accessibility help text when utility area is currently hidden") : String(localized: "status-bar.toggle-utility-area.hide", defaultValue: "Hide the Utility area", comment: "Accessibility help text when utility area is currently shown"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: "Toggle Utility Area",
                    title: "Toggle Utility Area",
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: "Toggle Utility Area",
                title: "Toggle Utility Area",
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
