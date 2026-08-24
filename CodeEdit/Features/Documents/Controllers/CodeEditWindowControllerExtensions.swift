//
//  CodeEditWindowControllerExtensions.swift
//  CodeEdit
//
//  Created by Austin Condiff on 10/14/23.
//

import Combine
import SwiftUI

extension CodeEditWindowController {
    /// These are example items that added as commands to command palette
    func registerCommands() {
        CommandManager.shared.addCommand(
            name: String(localized: "window-controller.commands.quick-open.title", defaultValue: "Quick Open", comment: "Command title for opening quick open panel"),
            title: String(localized: "window-controller.commands.quick-open.action", defaultValue: "Quick Open", comment: "Action label for quick open command"),
            id: "quick_open",
            command: { [weak self] in self?.openQuickly(nil) }
        )

        CommandManager.shared.addCommand(
            name: String(localized: "window-controller.commands.toggle-navigator.title", defaultValue: "Toggle Navigator", comment: "Command title for toggling navigator area"),
            title: String(localized: "window-controller.commands.toggle-navigator.action", defaultValue: "Toggle Navigator", comment: "Action label for toggling navigator area"),
            id: "toggle_left_sidebar",
            command: { [weak self] in self?.toggleFirstPanel() }
        )

        CommandManager.shared.addCommand(
            name: String(localized: "window-controller.commands.toggle-inspector.title", defaultValue: "Toggle Inspector", comment: "Command title for toggling inspector area"),
            title: String(localized: "window-controller.commands.toggle-inspector.action", defaultValue: "Toggle Inspector", comment: "Action label for toggling inspector area"),
            id: "toggle_right_sidebar",
            command: { [weak self] in self?.toggleLastPanel() }
        )
    }

    /// Listen to changes in all tabs/files
    func listenToDocumentEdited(workspace: WorkspaceDocument) {
        workspace.editorManager?.$activeEditor
            .flatMap { editor in
                editor.$tabs
            }
            .compactMap { tab in
                Publishers.MergeMany(tab.elements.compactMap { $0.file.fileDocumentPublisher })
            }
            .switchToLatest()
            .compactMap { fileDocument in
                fileDocument?.isDocumentEditedPublisher
            }
            .flatMap { $0 }
            .sink { isDocumentEdited in
                if isDocumentEdited {
                    self.setDocumentEdited(true)
                    return
                }

                self.updateDocumentEdited(workspace: workspace)
            }
            .store(in: &cancellables)

        // Listen to change of tabs, if closed tab without saving content,
        // we also need to recalculate isDocumentEdited
        workspace.editorManager?.$activeEditor
            .flatMap { editor in
                editor.$tabs
            }
            .sink { _ in
                self.updateDocumentEdited(workspace: workspace)
            }
            .store(in: &cancellables)
    }

    /// Recalculate documentEdited by checking if any tab/file is edited
    private func updateDocumentEdited(workspace: WorkspaceDocument) {
        let hasEditedDocuments = !(workspace
            .editorManager?
            .editorLayout
            .gatherOpenFiles()
            .filter { $0.fileDocument?.isDocumentEdited == true }
            .isEmpty ?? true)
        setDocumentEdited(hasEditedDocuments)
    }

    @IBAction func openWorkspaceSettings(_: Any) {
        guard let window = window,
              let workspace = workspace,
              let workspaceSettingsManager = workspace.workspaceSettingsManager,
              let taskManager = workspace.taskManager
        else { return }

        if let workspaceSettingsWindow, workspaceSettingsWindow.isVisible {
            workspaceSettingsWindow.makeKeyAndOrderFront(self)
        } else {
            let settingsWindow = NSWindow()
            workspaceSettingsWindow = settingsWindow
            let contentView = CEWorkspaceSettingsView(
                dismiss: { [weak self, weak settingsWindow] in
                    guard let settingsWindow else { return }
                    self?.window?.endSheet(settingsWindow)
                }
            )
            .environmentObject(workspaceSettingsManager)
            .environmentObject(workspace)
            .environmentObject(taskManager)

            settingsWindow.contentView = NSHostingView(rootView: contentView)
            settingsWindow.titlebarAppearsTransparent = true
            settingsWindow.setContentSize(NSSize(width: 515, height: 515))
            settingsWindow.setAccessibilityTitle(String(localized: "window-controller.commands.workspace-settings", defaultValue: "Workspace Settings", comment: "Command title for opening workspace settings"))

            window.beginSheet(settingsWindow, completionHandler: nil)
        }
    }
}

extension NSToolbarItem.Identifier {
    static let toggleFirstSidebarItem: NSToolbarItem.Identifier = .init("ToggleFirstSidebarItem")
    static let toggleLastSidebarItem: NSToolbarItem.Identifier = .init("ToggleLastSidebarItem")
    static let stopTaskSidebarItem: NSToolbarItem.Identifier = .init("StopTaskSidebarItem")
    static let startTaskSidebarItem: NSToolbarItem.Identifier = .init("StartTaskSidebarItem")
    static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
    static let branchPicker: NSToolbarItem.Identifier = .init("BranchPicker")
    static let activityViewer: NSToolbarItem.Identifier = .init("ActivityViewer")
    static let notificationItem = NSToolbarItem.Identifier("notificationItem")

    static let taskSidebarItem: NSToolbarItem.Identifier = .init("TaskSidebarItem")
}
