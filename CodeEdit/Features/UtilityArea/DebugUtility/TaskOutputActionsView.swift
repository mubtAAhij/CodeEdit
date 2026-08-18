//
//  TaskOutputActionsView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 27.06.24.
//

import SwiftUI

struct TaskOutputActionsView: View {
    @ObservedObject var activeTask: CEActiveTask
    @ObservedObject var taskManager: TaskManager
    @Binding var scrollProxy: ScrollViewProxy?

    @Namespace var bottomID
    var body: some View {
        HStack {
            Spacer()

            Button {
                Task {
                    await taskManager.runTask(task: activeTask.task)
                }
            } label: {
                Image(systemName: "memories")
                    .foregroundStyle(.green)
            }
            .buttonStyle(.icon)
            .help(String(localized: "utility-area.debug.task-output-actions.run-task", defaultValue: "Run Task", comment: "Tooltip for running selected task"))

            Button {
                taskManager.terminateTask(taskID: activeTask.task.id)
            } label: {
                Image(systemName: "stop.fill")
                    .foregroundStyle(
                        (activeTask.status == .running || activeTask.status == .stopped) ? .red : .gray
                    )
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .help(String(localized: "utility-area.debug.task-output-actions.stop-task", defaultValue: "Stop Task", comment: "Tooltip for stopping running task"))

            Button {
                if activeTask.status == .stopped {
                    activeTask.resume()
                } else if activeTask.status == .running {
                    activeTask.suspend()
                }
            } label: {
                if activeTask.status == .stopped {
                    Image(systemName: "play")
                } else {
                    Image(systemName: "pause")
                }
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .opacity(activeTask.status == .running || activeTask.status == .stopped ? 1 : 0.5)
            .help(activeTask.status == .stopped ? String(localized: "utility-area.debug.task-output-actions.resume-task", defaultValue: "Resume Task", comment: "Tooltip for resuming suspended task") : String(localized: "utility-area.debug.task-output-actions.suspend-task", defaultValue: "Suspend Task", comment: "Tooltip for suspending running task"))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: "text.append")
            }
            .buttonStyle(.icon)
            .help(String(localized: "utility-area.debug.task-output-actions.scroll-to-bottom", defaultValue: "Scroll down to the bottom", comment: "Tooltip for scrolling task output to latest line"))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.icon)
            .help(String(localized: "utility-area.debug.task-output-actions.clear-output", defaultValue: "Clear Output", comment: "Tooltip for clearing task output"))
        }
    }
}
