//
//  CodeEditWindowControllerExtensions.swift
//  CodeEdit
//
//  Created by Austin Condiff on 10/14/23.
//

import SwiftUI
import Combine

extension CodeEditWindowController {
    /// These are example items that added as commands to command palette
    func registerCommands() {
        CommandManager.shared.addCommand(
            name: String(localized: "command.quick_open.name", defaultValue: "Quick Open", comment: "Command name for quick open"),
            title: String(localized: "command.quick_open.title", defaultValue: "Quick Open", comment: "Command title for quick open"),
            id: String(localized: "command.quick_open.id", defaultValue: "quick_open", comment: "Command identifier for quick open"),
            command: { [weak self] in self?.openQuickly(nil) }
        )

        CommandManager.shared.addCommand(
            name: String(localized: "command.toggle_navigator.name", defaultValue: "Toggle Navigator", comment: "Command name for toggle navigator"),
            title: String(localized: "command.toggle_navigator.title", defaultValue: "Toggle Navigator", comment: "Command title for toggle navigator"),
            id: String(localized: "command.toggle_navigator.id", defaultValue: "toggle_left_sidebar", comment: "Command identifier for toggle navigator"),
            command: { [weak self] in self?.toggleFirstPanel() }
        )

        CommandManager.shared.addCommand(
            name: String(localized: "command.toggle_inspector.name", defaultValue: "Toggle Inspector", comment: "Command name for toggle inspector"),
            title: String(localized: "command.toggle_inspector.title", defaultValue: "Toggle Inspector", comment: "Command title for toggle inspector"),
            id: String(localized: "command.toggle_inspector.id", defaultValue: "toggle_right_sidebar", comment: "Command identifier for toggle inspector"),
            command: { [weak self] in self?.toggleLastPanel() }
        )
    }

    // Listen to changes in all tabs/files
    internal func listenToDocumentEdited(workspace: WorkspaceDocument) {
        workspace.editorManager?.$activeEditor
            .flatMap({ editor in
                editor.$tabs
            })
            .compactMap({ tab in
                Publishers.MergeMany(tab.elements.compactMap({ $0.file.fileDocumentPublisher }))
            })
            .switchToLatest()
            .compactMap({ fileDocument in
                fileDocument?.isDocumentEditedPublisher
            })
            .flatMap({ $0 })
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
            .flatMap({ editor in
                editor.$tabs
            })
            .sink { _ in
                self.updateDocumentEdited(workspace: workspace)
            }
            .store(in: &cancellables)
    }

    // Recalculate documentEdited by checking if any tab/file is edited
    private func updateDocumentEdited(workspace: WorkspaceDocument) {
        let hasEditedDocuments = !(workspace
            .editorManager?
            .editorLayout
            .gatherOpenFiles()
            .filter({ $0.fileDocument?.isDocumentEdited == true })
            .isEmpty ?? true)
        self.setDocumentEdited(hasEditedDocuments)
    }

    @IBAction func openWorkspaceSettings(_ sender: Any) {
        guard let window = window,
              let workspace = workspace,
              let workspaceSettingsManager = workspace.workspaceSettingsManager,
              let taskManager = workspace.taskManager
        else { return }

        if let workspaceSettingsWindow, workspaceSettingsWindow.isVisible {
            workspaceSettingsWindow.makeKeyAndOrderFront(self)
        } else {
            let settingsWindow = NSWindow()
            self.workspaceSettingsWindow = settingsWindow
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
            settingsWindow.setAccessibilityTitle(String(localized: "workspace_settings.accessibility_title", defaultValue: "Workspace Settings", comment: "Accessibility title for workspace settings window"))

            window.beginSheet(settingsWindow, completionHandler: nil)
        }
    }
}

extension NSToolbarItem.Identifier {
    static let toggleFirstSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.toggle_first_sidebar.identifier", defaultValue: "ToggleFirstSidebarItem", comment: "Toolbar identifier for toggle first sidebar"))
    static let toggleLastSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.toggle_last_sidebar.identifier", defaultValue: "ToggleLastSidebarItem", comment: "Toolbar identifier for toggle last sidebar"))
    static let stopTaskSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.stop_task.identifier", defaultValue: "StopTaskSidebarItem", comment: "Toolbar identifier for stop task"))
    static let startTaskSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.start_task.identifier", defaultValue: "StartTaskSidebarItem", comment: "Toolbar identifier for start task"))
    static let itemListTrackingSeparator = NSToolbarItem.Identifier(String(localized: "toolbar.item_list_separator.identifier", defaultValue: "ItemListTrackingSeparator", comment: "Toolbar identifier for item list separator"))
    static let branchPicker: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.branch_picker.identifier", defaultValue: "BranchPicker", comment: "Toolbar identifier for branch picker"))
    static let activityViewer: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.activity_viewer.identifier", defaultValue: "ActivityViewer", comment: "Toolbar identifier for activity viewer"))
    static let notificationItem = NSToolbarItem.Identifier(String(localized: "toolbar.notification.identifier", defaultValue: "notificationItem", comment: "Toolbar identifier for notification"))

    static let taskSidebarItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(String(localized: "toolbar.task_sidebar.identifier", defaultValue: "TaskSidebarItem", comment: "Toolbar identifier for task sidebar"))
}
