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
                Image(systemName: String(localized: "task.run.icon", defaultValue: "memories", comment: "Run task icon"))
                    .foregroundStyle(.green)
            }
            .buttonStyle(.icon)
            .help(String(localized: "task.run.help", defaultValue: "Run Task", comment: "Run task help text"))

            Button {
                taskManager.terminateTask(taskID: activeTask.task.id)
            } label: {
                Image(systemName: String(localized: "task.stop.icon", defaultValue: "stop.fill", comment: "Stop task icon"))
                    .foregroundStyle(
                        (activeTask.status == .running || activeTask.status == .stopped) ? .red : .gray
                    )
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .help(String(localized: "task.stop.help", defaultValue: "Stop Task", comment: "Stop task help text"))

            Button {
                if activeTask.status == .stopped {
                    activeTask.resume()
                } else if activeTask.status == .running {
                    activeTask.suspend()
                }
            } label: {
                if activeTask.status == .stopped {
                    Image(systemName: String(localized: "task.resume.icon", defaultValue: "play", comment: "Resume task icon"))
                } else {
                    Image(systemName: String(localized: "task.suspend.icon", defaultValue: "pause", comment: "Suspend task icon"))
                }
            }
            .buttonStyle(.icon)
            .disabled(!(activeTask.status == .running || activeTask.status == .stopped))
            .opacity(activeTask.status == .running || activeTask.status == .stopped ? 1 : 0.5)
            .help(activeTask.status == .stopped ? String(localized: "task.resume.help", defaultValue: "Resume Task", comment: "Resume task help text") : String(localized: "task.suspend.help", defaultValue: "Suspend Task", comment: "Suspend task help text"))

            Divider()

            Button {
                withAnimation {
                    scrollProxy?.scrollTo(bottomID, anchor: .bottom)
                }
            } label: {
                Image(systemName: String(localized: "task.scroll.icon", defaultValue: "text.append", comment: "Scroll to bottom icon"))
            }
            .buttonStyle(.icon)
            .help(String(localized: "task.scroll.help", defaultValue: "Scroll down to the bottom", comment: "Scroll to bottom help text"))

            Button {
                activeTask.clearOutput()
            } label: {
                Image(systemName: String(localized: "task.clear.icon", defaultValue: "trash", comment: "Clear output icon"))
            }
            .buttonStyle(.icon)
            .help(String(localized: "task.clear.help", defaultValue: "Clear Output", comment: "Clear output help text"))
        }
    }
}
