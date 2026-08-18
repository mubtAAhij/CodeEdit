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
            comment: "Top-level tasks command menu title"
        )) {
            let selectedTaskName: String = if let selectedTask = taskManager?.selectedTask {
                "\"" + selectedTask.name + "\""
            } else {
                String(
                    localized: "window-commands.tasks.no-selected-task",
                    defaultValue: "(No Selected Task)",
                    comment: "Menu item text shown when no task is selected"
                )
            }

            Button(String(format: String(
                localized: "window-commands.tasks.run-selected-task",
                defaultValue: "Run %@",
                comment: "Menu item title to run selected task"
            ), "\(selectedTaskName)"), systemImage: "play.fill") {
                taskManager?.executeActiveTask()
                showOutput()
            }
            .keyboardShortcut("R")
            .disabled(taskManager?.selectedTaskID == nil)

            Button(String(format: String(
                localized: "window-commands.tasks.stop-selected-task",
                defaultValue: "Stop %@",
                comment: "Menu item title to stop selected task"
            ), "\(selectedTaskName)"), systemImage: "stop.fill") {
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
                comment: "Menu item title to show selected task output"
            ), "\(selectedTaskName)")) {
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
                        comment: "Menu item title to create tasks"
                    )) {
                        openSettings()
                    }
                }
            } label: {
                Text(String(
                    localized: "window-commands.tasks.choose-task",
                    defaultValue: "Choose Task...",
                    comment: "Menu item title to choose active task"
                ))
            }
            .disabled(taskManager?.availableTasks.isEmpty == true)

            Button(String(
                localized: "window-commands.tasks.manage-tasks",
                defaultValue: "Manage Tasks...",
                comment: "Menu item title to open task management"
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
