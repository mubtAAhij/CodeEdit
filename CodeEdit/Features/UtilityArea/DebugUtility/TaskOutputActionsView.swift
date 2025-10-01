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
            .help(String(localized: "debug.action.run_task", comment: "Button title to run a task"))

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
            .help(String(localized: "debug.action.stop_task", comment: "Button title to stop a task"))

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
            .help(activeTask.status == .stopped ? String(localized: "debug.action.resume_task", comment: "Button title to resume a task") : String(localized: "debug.action.suspend_task", comment: "Button title to suspend a task"))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: "text.append")
            }
            .buttonStyle(.icon)
            .help(String(localized: "debug.action.scroll_to_bottom", comment: "Button tooltip to scroll to bottom"))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.icon)
            .help(String(localized: "debug.action.clear_output", comment: "Button title to clear output"))
        }
    }
}
