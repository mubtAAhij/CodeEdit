//
//  TasksCommands.swift
//  CodeEdit
//
//  Created by Khan Winter on 7/8/25.
//

import SwiftUI
import Combine

struct TasksCommands: Commands {
    @UpdatingWindowController var windowController: CodeEditWindowController?

    var taskManager: TaskManager? {
        windowController?.workspace?.taskManager
    }

    @State private var activeTaskStatus: CETaskStatus = .notRunning
    @State private var taskManagerListener: AnyCancellable?
    @State private var statusListener: AnyCancellable?

    var body: some Commands {
        CommandMenu(String(
    localized: "window-commands.tasks.menu-title",
    defaultValue: "Tasks",
    comment: "Title of the Tasks command menu"
)) {
            let selectedTaskName: String = if let selectedTask = taskManager?.selectedTask {
                "\"" + selectedTask.name + "\""
            } else {
                String(
    localized: "window-commands.tasks.no-selected-task",
    defaultValue: "(No Selected Task)",
    comment: "Placeholder shown when no task is selected"
)
            }

            Button(String(format: String(
    localized: "window-commands.tasks.run-selected-task",
    defaultValue: "Run %@",
    comment: "Run selected task command menu item"
), selectedTaskName), systemImage: "play.fill") {
                taskManager?.executeActiveTask()
                showOutput()
            }
            .keyboardShortcut("R")
            .disabled(taskManager?.selectedTaskID == nil)

            Button(String(format: String(
    localized: "window-commands.tasks.stop-selected-task",
    defaultValue: "Stop %@",
    comment: "Stop selected task command menu item"
), selectedTaskName), systemImage: "stop.fill") {
                taskManager?.terminateActiveTask()
            }
            .keyboardShortcut(".")
            .onChange(of: windowController) { _, _ in
                taskManagerListener = taskManager?.objectWillChange.sink {
                    updateStatusListener()
                }
            }
            .disabled(activeTaskStatus != .running)

            Button(String(format: String(
    localized: "window-commands.tasks.show-selected-task-output",
    defaultValue: "Show %@ Output",
    comment: "Show selected task output command menu item"
), selectedTaskName)) {
                showOutput()
            }
            // Disable when there's no output yet
            .disabled(taskManager?.activeTasks[taskManager?.selectedTaskID ?? UUID()] == nil)

            Divider()

            Menu {
                if let taskManager {
                    ForEach(taskManager.availableTasks) { task in
                        Button(task.name) {
                            taskManager.selectedTaskID = task.id
                        }
                    }
                }

                if taskManager?.availableTasks.isEmpty ?? true {
                    Button(String(
    localized: "window-commands.tasks.create-tasks",
    defaultValue: "Create Tasks",
    comment: "Create Tasks command menu item"
)) {
                        openSettings()
                    }
                }
            } label: {
                Text(String(
    localized: "window-commands.tasks.choose-task",
    defaultValue: "Choose Task...",
    comment: "Choose Task submenu label"
))
            }
            .disabled(taskManager?.availableTasks.isEmpty == true)

            Button(String(
    localized: "window-commands.tasks.manage-tasks",
    defaultValue: "Manage Tasks...",
    comment: "Manage Tasks command menu item"
)) {
                openSettings()
            }
            .disabled(windowController == nil)
        }
    }

    /// Update the ``statusListener`` to listen to a potentially new active task.
    private func updateStatusListener() {
        statusListener?.cancel()
        guard let taskManager else { return }

        activeTaskStatus = taskManager.activeTasks[taskManager.selectedTaskID ?? UUID()]?.status ?? .notRunning
        guard let id = taskManager.selectedTaskID else { return }

        statusListener = taskManager.activeTasks[id]?.$status.sink { newValue in
            activeTaskStatus = newValue
        }
    }

    private func showOutput() {
        guard let utilityAreaModel = windowController?.workspace?.utilityAreaModel else {
            return
        }
        if utilityAreaModel.isCollapsed {
            // Open the utility area
            utilityAreaModel.isCollapsed.toggle()
        }
        utilityAreaModel.selectedTab = .debugConsole // Switch to the correct tab
        taskManager?.taskShowingOutput = taskManager?.selectedTaskID // Switch to the selected task
    }

    private func openSettings() {
        NSApp.sendAction(
            #selector(CodeEditWindowController.openWorkspaceSettings(_:)),
            to: windowController,
            from: nil
        )
    }
}
