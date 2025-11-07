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
            .help(String(
                localized: "utility.task-output.run-task",
                defaultValue: "Run Task",
                comment: "Help text for button to run task"
            ))

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
            .help(String(
                localized: "utility.task-output.stop-task",
                defaultValue: "Stop Task",
                comment: "Help text for button to stop task"
            ))

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
            .help(activeTask.status == .stopped ? String(
                localized: "utility.task-output.resume-task",
                defaultValue: "Resume Task",
                comment: "Help text for button to resume task"
            ) : String(
                localized: "utility.task-output.suspend-task",
                defaultValue: "Suspend Task",
                comment: "Help text for button to suspend task"
            ))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: "text.append")
            }
            .buttonStyle(.icon)
            .help(String(
                localized: "utility.task-output.scroll-to-bottom",
                defaultValue: "Scroll down to the bottom",
                comment: "Help text for button to scroll to bottom"
            ))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.icon)
            .help(String(
                localized: "utility.task-output.clear-output",
                defaultValue: "Clear Output",
                comment: "Help text for button to clear output"
            ))
        }
    }
}
