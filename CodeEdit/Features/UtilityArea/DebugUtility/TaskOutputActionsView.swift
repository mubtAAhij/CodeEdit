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
                Image(systemName: String(localized: "task-output.run-icon", defaultValue: "memories", comment: "SF Symbol name for run task button"))
                    .foregroundStyle(.green)
            }
            .buttonStyle(.icon)
            .help(String(localized: "task-output.run-hint", defaultValue: "Run Task", comment: "Tooltip for run task button"))

            Button {
                taskManager.terminateTask(taskID: activeTask.task.id)
            } label: {
                Image(systemName: String(localized: "task-output.stop-icon", defaultValue: "stop.fill", comment: "SF Symbol name for stop task button"))
                    .foregroundStyle(
                        (activeTask.status == .running || activeTask.status == .stopped) ? .red : .gray
                    )
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .help(String(localized: "task-output.stop-hint", defaultValue: "Stop Task", comment: "Tooltip for stop task button"))

            Button {
                if activeTask.status == .stopped {
                    activeTask.resume()
                } else if activeTask.status == .running {
                    activeTask.suspend()
                }
            } label: {
                if activeTask.status == .stopped {
                    Image(systemName: String(localized: "task-output.play-icon", defaultValue: "play", comment: "SF Symbol name for play button"))
                } else {
                    Image(systemName: String(localized: "task-output.pause-icon", defaultValue: "pause", comment: "SF Symbol name for pause button"))
                }
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .opacity(activeTask.status == .running || activeTask.status == .stopped ? 1 : 0.5)
            .help(activeTask.status == .stopped ? String(localized: "task-output.resume-hint", defaultValue: "Resume Task", comment: "Tooltip for resume task button") : String(localized: "task-output.suspend-hint", defaultValue: "Suspend Task", comment: "Tooltip for suspend task button"))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: String(localized: "task-output.scroll-icon", defaultValue: "text.append", comment: "SF Symbol name for scroll to bottom button"))
            }
            .buttonStyle(.icon)
            .help(String(localized: "task-output.scroll-hint", defaultValue: "Scroll down to the bottom", comment: "Tooltip for scroll to bottom button"))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: String(localized: "task-output.clear-icon", defaultValue: "trash", comment: "SF Symbol name for clear output button"))
            }
            .buttonStyle(.icon)
            .help(String(localized: "task-output.clear-hint", defaultValue: "Clear Output", comment: "Tooltip for clear output button"))
        }
    }
}
