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
        CommandMenu(String(localized: "tasks.menu", defaultValue: "Tasks", comment: "Tasks menu")) {
            let selectedTaskName: String = if let selectedTask = taskManager?.selectedTask {
                "\"" + selectedTask.name + "\""
            } else {
                String(localized: "tasks.no.selected", defaultValue: "(No Selected Task)", comment: "No selected task placeholder")
            }

            Button(String(format: String(localized: "tasks.run.button", defaultValue: "Run %@", comment: "Run task button"), selectedTaskName), systemImage: String(localized: "tasks.run.icon", defaultValue: "play.fill", comment: "Run task icon")) {
                taskManager?.executeActiveTask()
                showOutput()
            }
            .keyboardShortcut(KeyEquivalent(Character(String(localized: "tasks.run.shortcut", defaultValue: "R", comment: "Run task keyboard shortcut"))))
            .disabled(taskManager?.selectedTaskID == nil)

            Button(String(format: String(localized: "tasks.stop.button", defaultValue: "Stop %@", comment: "Stop task button"), selectedTaskName), systemImage: String(localized: "tasks.stop.icon", defaultValue: "stop.fill", comment: "Stop task icon")) {
                taskManager?.terminateActiveTask()
            }
            .keyboardShortcut(KeyEquivalent(Character(String(localized: "tasks.stop.shortcut", defaultValue: ".", comment: "Stop task keyboard shortcut"))))
            .onChange(of: windowController) { _, _ in
                taskManagerListener = taskManager?.objectWillChange.sink {
                    updateStatusListener()
                }
            }
            .disabled(activeTaskStatus != .running)

            Button(String(format: String(localized: "tasks.show.output.button", defaultValue: "Show %@ Output", comment: "Show task output button"), selectedTaskName)) {
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
                    Button(String(localized: "tasks.create.button", defaultValue: "Create Tasks", comment: "Create tasks button")) {
                        openSettings()
                    }
                }
            } label: {
                Text(String(localized: "tasks.choose.button", defaultValue: "Choose Task...", comment: "Choose task button"))
            }
            .disabled(taskManager?.availableTasks.isEmpty == true)

            Button(String(localized: "tasks.manage.button", defaultValue: "Manage Tasks...", comment: "Manage tasks button")) {
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
