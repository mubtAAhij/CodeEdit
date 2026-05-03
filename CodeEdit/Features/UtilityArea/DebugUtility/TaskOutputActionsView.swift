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
            .help(String(localized: "task_output.run", defaultValue: "Run Task", comment: "Run task button tooltip"))

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
            .help(String(localized: "task_output.stop", defaultValue: "Stop Task", comment: "Stop task button tooltip"))

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
            .help(activeTask.status == .stopped ? String(localized: "task_output.resume", defaultValue: "Resume Task", comment: "Resume task button tooltip") : String(localized: "task_output.suspend", defaultValue: "Suspend Task", comment: "Suspend task button tooltip"))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: "text.append")
            }
            .buttonStyle(.icon)
            .help(String(localized: "task_output.scroll_bottom", defaultValue: "Scroll down to the bottom", comment: "Scroll to bottom button tooltip"))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.icon)
            .help(String(localized: "task_output.clear", defaultValue: "Clear Output", comment: "Clear output button tooltip"))
        }
    }
}
