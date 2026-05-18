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
        CommandMenu(String(localized: "tasks.menu.title", defaultValue: "Tasks", comment: "Tasks menu title in menu bar")) {
            let selectedTaskName: String = if let selectedTask = taskManager?.selectedTask {
                selectedTask.name
            } else {
                String(localized: "tasks.menu.no-selected-task", defaultValue: "(No Selected Task)", comment: "Placeholder text when no task is selected")
            }

            Button(String(localized: "tasks.menu.run", defaultValue: "Run \"\(selectedTaskName)\"", comment: "Button to run the selected task"), systemImage: "play.fill") {
                taskManager?.executeActiveTask()
                showOutput()
            }
            .keyboardShortcut("R")
            .disabled(taskManager?.selectedTaskID == nil)

            Button(String(localized: "tasks.menu.stop", defaultValue: "Stop \"\(selectedTaskName)\"", comment: "Button to stop the selected task"), systemImage: "stop.fill") {
                taskManager?.terminateActiveTask()
            }
            .keyboardShortcut(".")
            .onChange(of: windowController) { _, _ in
                taskManagerListener = taskManager?.objectWillChange.sink {
                    updateStatusListener()
                }
            }
            .disabled(activeTaskStatus != .running)

            Button(String(localized: "tasks.menu.show-output", defaultValue: "Show \"\(selectedTaskName)\" Output", comment: "Button to show output of the selected task")) {
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
                    Button(String(localized: "tasks.menu.create-tasks", defaultValue: "Create Tasks", comment: "Button to create new tasks when none exist")) {
                        openSettings()
                    }
                }
            } label: {
                Text(String(localized: "tasks.menu.choose-task", defaultValue: "Choose Task...", comment: "Label for task selection menu"))
            }
            .disabled(taskManager?.availableTasks.isEmpty == true)

            Button(String(localized: "tasks.menu.manage-tasks", defaultValue: "Manage Tasks...", comment: "Button to open task management settings")) {
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
