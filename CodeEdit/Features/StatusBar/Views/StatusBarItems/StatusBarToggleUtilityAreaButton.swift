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
        .help(utilityAreaViewModel.isCollapsed ? String(localized: "statusbar.utility.show", defaultValue: "Show the Utility area", comment: "Show utility area tooltip") : String(localized: "statusbar.utility.hide", defaultValue: "Hide the Utility area", comment: "Hide utility area tooltip"))
        .onHover { isHovering($0) }
        .onChange(of: controlActiveState) { _, newValue in
            if newValue == .key {
                CommandManager.shared.addCommand(
                    name: String(localized: "statusbar.utility.toggle", defaultValue: "Toggle Utility Area", comment: "Toggle utility area command"),
                    title: String(localized: "statusbar.utility.toggle", defaultValue: "Toggle Utility Area", comment: "Toggle utility area command"),
                    id: "open.drawer",
                    command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
                )
            }
        }
        .onAppear {
            CommandManager.shared.addCommand(
                name: String(localized: "statusbar.utility.toggle", defaultValue: "Toggle Utility Area", comment: "Toggle utility area command"),
                title: String(localized: "statusbar.utility.toggle", defaultValue: "Toggle Utility Area", comment: "Toggle utility area command"),
                id: "open.drawer",
                command: { [weak utilityAreaViewModel] in utilityAreaViewModel?.togglePanel() }
            )
        }
    }
}
