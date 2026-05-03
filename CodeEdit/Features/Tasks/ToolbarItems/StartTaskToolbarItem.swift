//
//  StartTaskToolbarItem.swift
//  CodeEdit
//
//  Created by Khan Winter on 8/28/25.
//

import AppKit

@available(macOS 26, *)
final class StartTaskToolbarItem: NSToolbarItem {
    private weak var workspace: WorkspaceDocument?

    private var utilityAreaCollapsed: Bool {
        workspace?.utilityAreaModel?.isCollapsed ?? true
    }

    init(workspace: WorkspaceDocument) {
        self.workspace = workspace
        super.init(itemIdentifier: NSToolbarItem.Identifier(String(localized: "tasks.toolbar.start_id", defaultValue: "StartTaskToolbarItem", comment: "Start task toolbar item identifier")))

        image = NSImage(systemSymbolName: String(localized: "tasks.toolbar.play_icon", defaultValue: "play.fill", comment: "SF Symbol for play/start icon"), accessibilityDescription: nil)
        let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        image = image?.withSymbolConfiguration(config) ?? image

        paletteLabel = String(localized: "tasks.toolbar.start_label", defaultValue: "Start Task", comment: "Start task toolbar item label")
        toolTip = String(localized: "tasks.toolbar.start_tooltip", defaultValue: "Run the selected task", comment: "Start task tooltip")
        target = self
        action = #selector(startTask)
        isBordered = true
    }

    @objc
    func startTask() {
        guard let taskManager = workspace?.taskManager else { return }

        taskManager.executeActiveTask()
        if utilityAreaCollapsed {
            CommandManager.shared.executeCommand(String(localized: "tasks.toolbar.command.open_drawer", defaultValue: "open.drawer", comment: "Command to open utility area drawer"))
        }
        workspace?.utilityAreaModel?.selectedTab = .debugConsole
        taskManager.taskShowingOutput = taskManager.selectedTaskID
    }
}
