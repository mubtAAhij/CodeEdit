//
//  CEWorkspaceSettingsTaskListView.swift
//  CodeEdit
//
//  Created by Tommy Ludwig on 01.07.24.
//

import SwiftUI

struct CEWorkspaceSettingsTaskListView: View {
    @EnvironmentObject var workspaceSettingsManager: CEWorkspaceSettings
    @EnvironmentObject var taskManager: TaskManager

    @ObservedObject var settings: CEWorkspaceSettingsData

    @Binding var selectedTaskID: UUID?
    @Binding var showAddTaskSheet: Bool

    var body: some View {
        if settings.tasks.isEmpty {
            Text(String(localized: "workspace.settings.tasks.no-tasks", defaultValue: "No tasks", comment: "Message shown when there are no tasks configured"))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(settings.tasks) { task in
                TaskTile(task: task)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedTaskID = task.id
                        self.showAddTaskSheet = true
                    }
                    .contextMenu {
                        Button {
                            self.selectedTaskID = task.id
                            self.showAddTaskSheet = true
                        } label: {
                            Text(String(localized: "workspace.settings.tasks.edit", defaultValue: "Edit", comment: "Context menu item to edit a task"))
                        }
                        Button {
                            settings.tasks.removeAll { $0.id == task.id }
                            try? workspaceSettingsManager.savePreferences()
                            taskManager.deleteTask(taskID: task.id)
                        } label: {
                            Text(String(localized: "workspace.settings.tasks.delete", defaultValue: "Delete", comment: "Context menu item to delete a task"))
                        }
                    }
            }
        }
    }

    // Every task as to be observed individually
    private struct TaskTile: View {
        @ObservedObject var task: CETask
        var body: some View {
            HStack {
                Text(task.name)
                Spacer()
                Group {
                    Text(task.command)
                    Image(systemName: "chevron.right")
                }
                .font(.system(.body, design: .monospaced))
            }
        }
    }
}
